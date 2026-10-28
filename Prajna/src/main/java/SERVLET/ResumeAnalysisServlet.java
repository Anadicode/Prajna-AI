
package SERVLET;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;

import SERVICE.NemotronService;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/analyze-resume")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class ResumeAnalysisServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private NemotronService nemotronService;

    @Override
    public void init() throws ServletException {
        nemotronService = new NemotronService();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        Part resumePart;

        try {
            resumePart = request.getPart("resume");
        } catch (IllegalStateException e) {
            showError(request, response,
                    "The uploaded file is too large. Maximum size is 5 MB.");
            return;
        }

        if (resumePart == null || resumePart.getSize() == 0) {
            showError(request, response,
                    "Please select a PDF or DOCX resume.");
            return;
        }

        String fileName = resumePart.getSubmittedFileName();

        if (fileName == null) {
            showError(request, response,
                    "Could not identify the uploaded file.");
            return;
        }

        String lowerName = fileName.toLowerCase(Locale.ROOT);

        if (!lowerName.endsWith(".pdf")
                && !lowerName.endsWith(".docx")) {
            showError(request, response,
                    "Please upload a PDF or DOCX file.");
            return;
        }

        String resumeText;

        try (InputStream input = resumePart.getInputStream()) {
            byte[] fileBytes = input.readAllBytes();

            if (lowerName.endsWith(".pdf")) {
                try (PDDocument document = Loader.loadPDF(fileBytes)) {
                    resumeText = new PDFTextStripper()
                            .getText(document);
                }
            } else {
                try (XWPFDocument document = new XWPFDocument(
                            new ByteArrayInputStream(fileBytes));
                     XWPFWordExtractor extractor =
                            new XWPFWordExtractor(document)) {

                    resumeText = extractor.getText();
                }
            }
        } catch (IOException e) {
            getServletContext().log(
                    "Failed to extract text from uploaded resume.", e);

            showError(request, response,
                    "Unable to read this file. Please upload a valid PDF or DOCX.");
            return;
        }

        if (resumeText == null || resumeText.isBlank()) {
            showError(request, response,
                    "No readable text found. Scanned PDFs may require OCR.");
            return;
        }

        String jobDescription = request.getParameter("jobDescription");

        if (jobDescription != null && !jobDescription.isBlank()) {
            resumeText += "\n\nJOB DESCRIPTION:\n" + jobDescription;
        }

        try {
            String analysis = nemotronService.analyzeResume(resumeText);

            request.setAttribute("analysis", analysis);
            request.getRequestDispatcher("/result.jsp")
                    .forward(request, response);

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new ServletException(
                    "Resume analysis was interrupted.", e);

        } catch (IOException e) {
            getServletContext().log(
                    "Resume analysis API request failed.", e);

            response.setStatus(HttpServletResponse.SC_BAD_GATEWAY);

            showError(request, response,
                    "The AI service failed to process your resume. "
                    + "Check your API configuration and try again.");

        } catch (IllegalStateException e) {
            getServletContext().log(
                    "AI API configuration error.", e);

            showError(request, response,
                    "The API key is not configured. Set OPENROUTER_API_KEY "
                    + "in the Tomcat environment and restart Tomcat.");
        }
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);
        request.getRequestDispatcher("/index.jsp")
                .forward(request, response);
    }
}

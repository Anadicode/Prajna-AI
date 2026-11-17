
package SERVLET;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Locale;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;

import SERVICE.ResumeComparisonService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/CompaireResume")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 11 * 1024 * 1024
)
public class CompaireResumeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;

    private final ResumeComparisonService comparisonService =
            new ResumeComparisonService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/CompaireResume.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {

            Part beforePart = request.getPart("beforeResume");
            Part afterPart = request.getPart("afterResume");

            String jobDescription =
                    request.getParameter("jobDescription");

            validateUploadedFiles(beforePart, afterPart);

            String oldResumeText =
                    extractResumeText(beforePart);

            String newResumeText =
                    extractResumeText(afterPart);

            if (oldResumeText.isBlank()
                    || newResumeText.isBlank()) {

                throw new IllegalArgumentException(
                        "Could not extract readable text from one or both resumes.");
            }

            String comparisonReport =
                    comparisonService.compareResumeVersions(
                            oldResumeText,
                            newResumeText,
                            jobDescription
                    );

            if (comparisonReport == null
                    || comparisonReport.isBlank()) {

                throw new IOException(
                        "AI returned an empty comparison report.");
            }

            request.setAttribute(
                    "comparisonReport",
                    comparisonReport
            );

            request.getRequestDispatcher("/CompaireResume.jsp")
                    .forward(request, response);

        } catch (IllegalArgumentException e) {

            showError(request, response, e.getMessage());

        } catch (IllegalStateException e) {

            log("Resume upload limit exceeded or invalid multipart request.", e);

            showError(
                    request,
                    response,
                    "The uploaded files exceed the allowed size. "
                    + "Each resume must be 5 MB or smaller."
            );

        } catch (InterruptedException e) {

            Thread.currentThread().interrupt();

            log("Resume comparison request was interrupted.", e);

            showError(
                    request,
                    response,
                    "The comparison request was interrupted. Please try again."
            );

        } catch (Exception e) {

            log("Resume comparison failed.", e);

            showError(
                    request,
                    response,
                    "Unable to compare resumes right now. "
                    + "Please try again later."
            );
        }
    }

    private void validateUploadedFiles(
            Part beforePart,
            Part afterPart) {

        if (beforePart == null || afterPart == null
                || beforePart.getSize() == 0
                || afterPart.getSize() == 0) {

            throw new IllegalArgumentException(
                    "Please upload both resume versions.");
        }

        if (beforePart.getSize() > MAX_FILE_SIZE
                || afterPart.getSize() > MAX_FILE_SIZE) {

            throw new IllegalArgumentException(
                    "Each resume must be 5 MB or smaller.");
        }
    }

    private String extractResumeText(Part filePart)
            throws IOException {

        String fileName = filePart.getSubmittedFileName();

        if (fileName == null || fileName.isBlank()) {

            throw new IllegalArgumentException(
                    "Invalid resume file.");
        }

        int lastDot = fileName.lastIndexOf('.');

        if (lastDot < 0 || lastDot == fileName.length() - 1) {

            throw new IllegalArgumentException(
                    "Resume file must have a valid extension.");
        }

        String extension = fileName.substring(lastDot + 1)
                .toLowerCase(Locale.ROOT);

        byte[] fileBytes;

        try (var inputStream = filePart.getInputStream()) {
            fileBytes = inputStream.readAllBytes();
        }

        if (fileBytes.length == 0) {

            throw new IllegalArgumentException(
                    "Uploaded file is empty.");
        }

        String extractedText;

        switch (extension) {

            case "pdf":

                try (PDDocument document = Loader.loadPDF(fileBytes)) {

                    extractedText = new PDFTextStripper()
                            .getText(document);
                }

                break;

            case "docx":

                try (XWPFDocument document = new XWPFDocument(
                        new ByteArrayInputStream(fileBytes))) {

                    try (XWPFWordExtractor extractor =
                            new XWPFWordExtractor(document)) {

                        extractedText = extractor.getText();
                    }
                }

                break;

            case "doc":

                try (HWPFDocument document = new HWPFDocument(
                        new ByteArrayInputStream(fileBytes))) {

                    try (WordExtractor extractor =
                            new WordExtractor(document)) {

                        extractedText = extractor.getText();
                    }
                }

                break;

            default:

                throw new IllegalArgumentException(
                        "Only PDF, DOC and DOCX files are supported.");
        }

        if (extractedText == null || extractedText.isBlank()) {

            throw new IllegalArgumentException(
                    "No readable text found in " + fileName
                    + ". If this is a scanned PDF, OCR is required.");
        }

        return extractedText.trim();
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute(
                "errorMessage",
                message == null
                        ? "Unable to process your request."
                        : message
        );

        request.getRequestDispatcher("/CompaireResume.jsp")
                .forward(request, response);
    }
}

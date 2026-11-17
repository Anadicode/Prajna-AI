
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Resume Comparison | Prajna AI</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', 'Segoe UI', sans-serif;
    background: #090b12;
    color: #f1f5f9;
    min-height: 100vh;
}

.container {
    max-width: 1150px;
    margin: auto;
    padding: 35px 25px;
}

.header {
    margin-bottom: 30px;
}

.back-link {
    color: #a78bfa;
    text-decoration: none;
    font-size: 14px;
}

.header h1 {
    font-size: 32px;
    margin: 25px 0 10px;
}

.header h1 span {
    color: #a78bfa;
}

.header p {
    color: #94a3b8;
    line-height: 1.7;
    font-size: 14px;
}

/* Upload section */

.upload-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 22px;
    margin-top: 25px;
}

.upload-card,
.card,
.result-card {
    background: #111522;
    border: 1px solid #252b3b;
    border-radius: 15px;
    padding: 25px;
    margin-bottom: 22px;
}

.card-heading {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 15px;
}

.step {
    width: 36px;
    height: 36px;
    background: #31245b;
    color: #c4b5fd;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
}

.card-heading h2 {
    font-size: 18px;
}

.card-title {
    font-size: 18px;
    margin-bottom: 18px;
}

.muted {
    color: #94a3b8;
    font-size: 13px;
    line-height: 1.6;
}

.drop-zone {
    display: block;
    background: #0d111d;
    border: 2px dashed #353d52;
    border-radius: 12px;
    padding: 35px 15px;
    text-align: center;
    cursor: pointer;
    transition: 0.25s;
    margin-top: 20px;
}

.drop-zone:hover,
.drop-zone.dragover {
    border-color: #8b5cf6;
    background: #17132a;
}

.upload-icon {
    font-size: 35px;
    margin-bottom: 12px;
}

.drop-zone h3 {
    font-size: 15px;
    margin-bottom: 8px;
}

.drop-zone p {
    font-size: 12px;
    color: #94a3b8;
    margin-top: 8px;
}

.drop-zone strong {
    color: #a78bfa;
}

.file-input {
    display: none;
}

.file-info {
    display: none;
    margin-top: 15px;
    padding: 12px;
    background: #1a2030;
    border-radius: 9px;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
}

.file-info.show {
    display: flex;
}

.file-name {
    font-size: 12px;
    color: #cbd5e1;
    overflow-wrap: anywhere;
}

.remove-file {
    background: transparent;
    border: none;
    color: #f87171;
    cursor: pointer;
}

/* Job description */

.job-description {
    width: 100%;
    min-height: 140px;
    resize: vertical;
    background: #0d111d;
    border: 1px solid #353d52;
    border-radius: 10px;
    padding: 15px;
    color: white;
    font-family: inherit;
    font-size: 13px;
    outline: none;
}

.job-description:focus {
    border-color: #8b5cf6;
}

.job-description::placeholder {
    color: #64748b;
}

/* Buttons */

.compare-section {
    text-align: center;
    margin: 30px 0 50px;
}

.compare-btn {
    background: linear-gradient(135deg, #7c3aed, #6366f1);
    border: none;
    padding: 15px 35px;
    color: white;
    font-size: 15px;
    font-weight: 600;
    border-radius: 10px;
    cursor: pointer;
    transition: 0.25s;
}

.compare-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 25px #7c3aed40;
}

.compare-btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
}

.note {
    margin-top: 13px;
    color: #64748b;
    font-size: 12px;
}

/* Error */

.error-message {
    background: #351720;
    border: 1px solid #7f2938;
    color: #fca5a5;
    padding: 15px;
    border-radius: 10px;
    margin: 20px 0;
    font-size: 13px;
}

/* Results */

.results {
    margin-top: 45px;
}

.section-title {
    font-size: 25px;
    margin-bottom: 8px;
}

/* AI report */

.ai-report-card {
    background: #111522;
    border: 1px solid #252b3b;
    border-radius: 15px;
    padding: 25px;
    margin: 22px 0;
}

.ai-report-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 22px;
}

.ai-report-icon {
    width: 42px;
    height: 42px;
    min-width: 42px;
    background: #31245b;
    color: #c4b5fd;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 21px;
}

.ai-report-heading h3 {
    font-size: 17px;
    margin-bottom: 5px;
}

.ai-report-subtitle {
    color: #94a3b8;
    font-size: 12px;
}

.ai-report {
    background: #0d111d;
    border: 1px solid #353d52;
    border-radius: 12px;
    padding: 25px;
}

.ai-report-content {
    color: #cbd5e1;
    font-size: 14px;
    line-height: 1.9;
    white-space: pre-wrap;
    overflow-wrap: anywhere;
}

.ai-report-footer {
    border-top: 1px solid #252b3b;
    margin-top: 20px;
    padding-top: 15px;
    color: #64748b;
    font-size: 12px;
    line-height: 1.7;
}

/* Responsive */

@media(max-width: 700px) {

    .upload-grid {
        grid-template-columns: 1fr;
    }

    .header h1 {
        font-size: 25px;
    }

    .container {
        padding: 25px 15px;
    }

    .upload-card,
    .card,
    .result-card,
    .ai-report-card {
        padding: 18px;
    }

    .ai-report {
        padding: 17px;
    }
}
</style>
</head>

<body>

<div class="container">

    <!-- HEADER -->

    <div class="header">

        <a href="<%=application.getContextPath() %>/"
           class="back-link">
            ← Back to Dashboard
        </a>

        <h1>
            Resume <span>Version Comparison</span>
        </h1>

        <p>
            Compare two versions of your resume, discover meaningful
            improvements, identify missing skills and understand
            what still needs attention.
        </p>

    </div>

    <!-- ERROR MESSAGE -->

    <c:if test="${not empty errorMessage}">
        <div class="error-message">
            <c:out value="${errorMessage}"/>
        </div>
    </c:if>

    <!-- UPLOAD FORM -->

    <form action="<%= application.getContextPath() %>/CompaireResume"
          method="post"
          enctype="multipart/form-data"
          id="comparisonForm">

        <div class="upload-grid">

            <!-- ORIGINAL RESUME -->

            <div class="upload-card">

                <div class="card-heading">
                    <div class="step">01</div>
                    <h2>Original Resume</h2>
                </div>

                <p class="muted">
                    Upload your resume before making improvements.
                </p>

                <label class="drop-zone"
                       id="beforeZone"
                       for="beforeResume">

                    <div class="upload-icon">📄</div>

                    <h3>Upload Original Resume</h3>

                    <p>
                        Drag and drop or
                        <strong>browse files</strong>
                    </p>

                    <p>PDF, DOC, DOCX · Maximum 5 MB</p>

                </label>

                <input type="file"
                       id="beforeResume"
                       name="beforeResume"
                       class="file-input"
                       accept=".pdf,.doc,.docx"
                       required>

                <div class="file-info" id="beforeInfo">

                    <span class="file-name" id="beforeName"></span>

                    <button type="button"
                            class="remove-file"
                            onclick="removeFile('beforeResume','beforeInfo')">
                        Remove
                    </button>

                </div>

            </div>

            <!-- IMPROVED RESUME -->

            <div class="upload-card">

                <div class="card-heading">
                    <div class="step">02</div>
                    <h2>Improved Resume</h2>
                </div>

                <p class="muted">
                    Upload your updated resume after making improvements.
                </p>

                <label class="drop-zone"
                       id="afterZone"
                       for="afterResume">

                    <div class="upload-icon">✨</div>

                    <h3>Upload Improved Resume</h3>

                    <p>
                        Drag and drop or
                        <strong>browse files</strong>
                    </p>

                    <p>PDF, DOC, DOCX · Maximum 5 MB</p>

                </label>

                <input type="file"
                       id="afterResume"
                       name="afterResume"
                       class="file-input"
                       accept=".pdf,.doc,.docx"
                       required>

                <div class="file-info" id="afterInfo">

                    <span class="file-name" id="afterName"></span>

                    <button type="button"
                            class="remove-file"
                            onclick="removeFile('afterResume','afterInfo')">
                        Remove
                    </button>

                </div>

            </div>

        </div>

        <!-- JOB DESCRIPTION -->

        <div class="card" style="margin-top:25px;">

            <h3 class="card-title">
                Target Job Description
                <span style="color:#94a3b8;font-size:12px;">
                    (Recommended)
                </span>
            </h3>

            <p class="muted" style="margin-bottom:15px;">
                Provide the job description so Prajna AI can evaluate
                how well both resume versions match the target role.
            </p>

            <textarea name="jobDescription"
                      class="job-description"
                      placeholder="Paste the target job description here..."><c:out value="${param.jobDescription}"/></textarea>

            <p class="note">
                Without a job description, job-specific keyword analysis
                will not be available.
            </p>

        </div>

        <!-- SUBMIT -->

        <div class="compare-section">

            <button type="submit"
                    class="compare-btn"
                    id="compareBtn">

                Compare My Resumes →

            </button>

            <p class="note">
                AI will analyze the differences between both resume versions.
            </p>

        </div>

    </form>

    <!-- TEXT-BASED COMPARISON RESULTS -->

    <c:if test="${not empty comparisonReport}">

        <div class="results" id="comparisonResults">

            <h2 class="section-title">
                Comparison Results
            </h2>

            <p class="muted">
                Your AI-generated resume comparison is ready.
            </p>

            <div class="ai-report-card">

                <div class="ai-report-header">

                    <div class="ai-report-icon">
                        ✦
                    </div>

                    <div class="ai-report-heading">

                        <h3>
                            Prajna AI – Resume Comparison Report
                        </h3>

                        <p class="ai-report-subtitle">
                            Detailed analysis of your original and improved resumes
                        </p>

                    </div>

                </div>

                <div class="ai-report">

                    <div class="ai-report-content">
                        <c:out value="${comparisonReport}"/>
                    </div>

                </div>

                <div class="ai-report-footer">

                    This report is AI-generated using the content
                    extracted from both uploaded resume versions.
                    Review all suggested changes carefully and ensure
                    that every claim in your resume is accurate.

                </div>

            </div>

        </div>

    </c:if>

</div>

<script>

const maxSize = 5 * 1024 * 1024;

function setupUpload(inputId, zoneId, infoId, nameId) {

    const input = document.getElementById(inputId);
    const zone = document.getElementById(zoneId);
    const info = document.getElementById(infoId);
    const name = document.getElementById(nameId);

    input.addEventListener("change", function() {
        validateFile(input, info, name);
    });

    zone.addEventListener("dragover", function(e) {
        e.preventDefault();
        zone.classList.add("dragover");
    });

    zone.addEventListener("dragleave", function() {
        zone.classList.remove("dragover");
    });

    zone.addEventListener("drop", function(e) {

        e.preventDefault();

        zone.classList.remove("dragover");

        if (e.dataTransfer.files.length > 0) {

            try {
                input.files = e.dataTransfer.files;
                validateFile(input, info, name);
            } catch (error) {
                alert("Unable to select the dropped file. Please browse instead.");
            }
        }

    });
}

function validateFile(input, info, name) {

    const file = input.files[0];

    if (!file) {
        info.classList.remove("show");
        return;
    }

    const allowed = /\.(pdf|doc|docx)$/i;

    if (!allowed.test(file.name)) {

        alert("Only PDF, DOC and DOCX files are allowed.");

        input.value = "";
        info.classList.remove("show");

        return;
    }

    if (file.size === 0) {

        alert("The selected file is empty.");

        input.value = "";
        info.classList.remove("show");

        return;
    }

    if (file.size > maxSize) {

        alert("File size must not exceed 5 MB.");

        input.value = "";
        info.classList.remove("show");

        return;
    }

    name.textContent = file.name;

    info.classList.add("show");
}

function removeFile(inputId, infoId) {

    document.getElementById(inputId).value = "";

    document.getElementById(infoId).classList.remove("show");
}

setupUpload(
    "beforeResume",
    "beforeZone",
    "beforeInfo",
    "beforeName"
);

setupUpload(
    "afterResume",
    "afterZone",
    "afterInfo",
    "afterName"
);

document.getElementById("comparisonForm").addEventListener(
    "submit",
    function(e) {

        const before =
            document.getElementById("beforeResume").files[0];

        const after =
            document.getElementById("afterResume").files[0];

        if (!before || !after) {

            e.preventDefault();

            alert("Please upload both resume versions.");

            return;
        }

        if (before.size === 0 || after.size === 0 ||
            before.size > maxSize || after.size > maxSize) {

            e.preventDefault();

            alert("Please select valid resume files under 5 MB.");

            return;
        }

        const button = document.getElementById("compareBtn");

        button.disabled = true;

        button.textContent = "Analyzing Both Resumes...";

    }
);

</script>

</body>
</html>

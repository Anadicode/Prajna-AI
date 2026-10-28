
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ResumeAI | Resume Analyzer</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #090d18;
            color: #f8fafc;
            min-height: 100vh;
        }

        nav {
            min-height: 76px;
            padding: 0 8%;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #0c1220;
            border-bottom: 1px solid #20283a;
        }

        .logo {
            font-size: 24px;
            font-weight: 750;
            letter-spacing: -1px;
        }

        .logo span {
            color: #8b7cff;
        }

        .nav-label {
            color: #aab4c8;
            font-size: 14px;
        }

        main {
            width: min(900px, 92%);
            margin: 55px auto;
        }

        .intro {
            text-align: center;
            margin-bottom: 36px;
        }

        .tag {
            display: inline-block;
            padding: 8px 14px;
            border: 1px solid #37305f;
            border-radius: 30px;
            background: #17132e;
            color: #b7aaff;
            font-size: 12px;
            font-weight: 650;
            margin-bottom: 20px;
        }

        h1 {
            font-size: clamp(30px, 5vw, 43px);
            letter-spacing: -1.5px;
            margin-bottom: 15px;
        }

        .intro p {
            color: #9ca9bd;
            line-height: 1.7;
            font-size: 15px;
        }

        .card {
            padding: 34px;
            background: #111827;
            border: 1px solid #273247;
            border-radius: 20px;
            box-shadow: 0 25px 70px #00000030;
        }

        .section-title {
            font-size: 19px;
            margin-bottom: 8px;
        }

        .section-subtitle {
            font-size: 13px;
            color: #98a6bb;
            margin-bottom: 22px;
        }

        /* Error message returned by the servlet */
        .error-message {
            background: #3b1720;
            color: #fecaca;
            border: 1px solid #7f303d;
            padding: 13px 15px;
            border-radius: 9px;
            margin-bottom: 20px;
            font-size: 14px;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        .drop-zone {
            min-height: 230px;
            border: 2px dashed #424268;
            border-radius: 15px;
            background: #0c1220;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 25px;
            cursor: pointer;
            transition: 0.2s;
        }

        .drop-zone:hover,
        .drop-zone.dragover {
            border-color: #9485ff;
            background: #17152b;
        }

        .drop-zone:focus-visible {
            outline: 2px solid #a99bff;
            outline-offset: 4px;
        }

        .upload-icon {
            width: 58px;
            height: 58px;
            display: grid;
            place-items: center;
            background: #242044;
            border-radius: 16px;
            color: #b7aaff;
            font-size: 28px;
            margin-bottom: 17px;
        }

        .drop-zone h3 {
            font-size: 16px;
            margin-bottom: 9px;
        }

        .drop-zone p {
            color: #9ca9bd;
            font-size: 13px;
            line-height: 1.7;
        }

        .browse {
            color: #a99bff;
            font-weight: 650;
            text-decoration: underline;
        }

        .file-name {
            color: #a99bff !important;
            margin-top: 12px;
            overflow-wrap: anywhere;
        }

        .file-input {
            position: absolute;
            width: 1px;
            height: 1px;
            opacity: 0;
            overflow: hidden;
        }

        .field {
            margin-top: 28px;
        }

        .field label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 11px;
        }

        .optional {
            color: #8996ab;
            font-weight: 400;
        }

        textarea {
            width: 100%;
            min-height: 145px;
            resize: vertical;
            padding: 15px;
            background: #0c1220;
            border: 1px solid #303b50;
            border-radius: 11px;
            color: #f8fafc;
            font: inherit;
            font-size: 14px;
            outline: none;
        }

        textarea:focus {
            border-color: #9485ff;
            box-shadow: 0 0 0 3px #9485ff20;
        }

        textarea::placeholder {
            color: #6f7d92;
        }

        .hint {
            color: #8996ab;
            font-size: 12px;
            margin-top: 9px;
        }

        .submit-btn {
            width: 100%;
            margin-top: 27px;
            padding: 15px 20px;
            border: none;
            border-radius: 11px;
            background: linear-gradient(100deg, #7664ed, #9b76f5);
            color: white;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }

        .submit-btn:hover {
            filter: brightness(1.12);
            transform: translateY(-1px);
        }

        .submit-btn:disabled {
            opacity: 0.6;
            cursor: wait;
            transform: none;
        }

        .privacy {
            text-align: center;
            margin-top: 18px;
            color: #8996ab;
            font-size: 12px;
            line-height: 1.7;
        }

        footer {
            text-align: center;
            color: #718096;
            font-size: 12px;
            padding: 0 15px 28px;
        }

        @media (max-width: 600px) {
            nav {
                padding: 0 5%;
                min-height: 65px;
            }

            .logo {
                font-size: 21px;
            }

            .nav-label {
                font-size: 12px;
            }

            main {
                margin: 35px auto;
            }

            .card {
                padding: 22px 17px;
            }

            .intro p {
                font-size: 14px;
            }

            .drop-zone {
                min-height: 210px;
            }
        }
    </style>
</head>

<body>

<nav>
    <div class="logo">Resume<span>AI</span></div>
    <div class="nav-label">AI-powered career insights</div>
</nav>

<main>
    <section class="intro">
        <div class="tag">✦ SMART RESUME ANALYSIS</div>

        <h1>
            Make your resume
            <span style="color:#a99bff">stand out.</span>
        </h1>

        <p>
            Upload your resume and compare it with your target job.
            <br>
            Discover skill gaps and get actionable suggestions to improve.
        </p>
    </section>

    <section class="card">
        <h2 class="section-title">Analyze your resume</h2>

        <p class="section-subtitle">
            Upload your document and optionally add a job description.
        </p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message" role="alert">
                <%= org.apache.commons.text.StringEscapeUtils.escapeHtml4(
                    String.valueOf(request.getAttribute("error"))
                ) %>
            </div>
        <% } %>

        <form id="resumeForm"
              action="<%=application.getContextPath()%>/analyze-resume"
              method="post"
              enctype="multipart/form-data">

            <input
                class="file-input"
                type="file"
                id="resume"
                name="resume"
                accept=".pdf,.docx"
                required>

            <label class="drop-zone"
                   id="dropZone"
                   for="resume"
                   tabindex="0"
                   role="button">

                <div class="upload-icon">↑</div>

                <h3>Drag and drop your resume here</h3>

                <p>
                    or <span class="browse">browse files</span>
                    from your device
                </p>

                <p style="margin-top:12px">
                    Supported formats: PDF, DOCX · Maximum size: 5 MB
                </p>

                <p class="file-name"
                   id="fileName"
                   aria-live="polite">
                    No file selected
                </p>
            </label>

            <div class="field">
                <label for="jobDescription">
                    Job description
                    <span class="optional">(optional)</span>
                </label>

                <textarea
                    id="jobDescription"
                    name="jobDescription"
                    placeholder="Paste the job description here to compare your resume against the role..."></textarea>

                <p class="hint">
                    Adding a job description enables more relevant job-match insights.
                </p>
            </div>

            <button class="submit-btn"
                    type="submit"
                    id="submitBtn">
                ✨ Analyze My Resume →
            </button>
        </form>

        <p class="privacy">
            Your resume may contain personal information.
            Upload only documents you are comfortable processing.
        </p>
    </section>
</main>

<footer>
    ResumeAI · Build a stronger resume, one step at a time.
</footer>

<script>
    const fileInput = document.getElementById("resume");
    const dropZone = document.getElementById("dropZone");
    const fileName = document.getElementById("fileName");
    const form = document.getElementById("resumeForm");
    const submitBtn = document.getElementById("submitBtn");

    const MAX_SIZE = 5 * 1024 * 1024;

    function validateFile(file) {
        if (!file) {
            fileName.textContent = "No file selected";
            return false;
        }

        const validExtension = /\.(pdf|docx)$/i.test(file.name);

        if (!validExtension) {
            alert("Please select a PDF or DOCX file.");
            fileInput.value = "";
            fileName.textContent = "No file selected";
            return false;
        }

        if (file.size > MAX_SIZE) {
            alert("File size must be 5 MB or less.");
            fileInput.value = "";
            fileName.textContent = "No file selected";
            return false;
        }

        fileName.textContent =
            "✓ Selected: " + file.name +
            " (" + (file.size / (1024 * 1024)).toFixed(2) + " MB)";

        return true;
    }

    // Show the selected filename.
    fileInput.addEventListener("change", function () {
        validateFile(fileInput.files[0]);
    });

    // Keyboard accessibility for the upload area.
    dropZone.addEventListener("keydown", function (event) {
        if (event.key === "Enter" || event.key === " ") {
            event.preventDefault();
            fileInput.click();
        }
    });

    // Highlight the drop area while dragging.
    ["dragenter", "dragover"].forEach(function (eventName) {
        dropZone.addEventListener(eventName, function (event) {
            event.preventDefault();
            dropZone.classList.add("dragover");
        });
    });

    ["dragleave", "drop"].forEach(function (eventName) {
        dropZone.addEventListener(eventName, function (event) {
            event.preventDefault();
            dropZone.classList.remove("dragover");
        });
    });

    // Support drag and drop.
    dropZone.addEventListener("drop", function (event) {
        const files = event.dataTransfer.files;

        if (!files || files.length === 0) {
            return;
        }

        const file = files[0];

        try {
            const transfer = new DataTransfer();
            transfer.items.add(file);
            fileInput.files = transfer.files;

            validateFile(fileInput.files[0]);
        } catch (error) {
            alert("Please click the upload area and select your file instead.");
        }
    });

    // Validate before submitting.
    form.addEventListener("submit", function (event) {
        const file = fileInput.files[0];

        if (!validateFile(file)) {
            event.preventDefault();
            return;
        }

        submitBtn.disabled = true;
        submitBtn.textContent = "Uploading and analyzing...";
    });
</script>

</body>
</html>

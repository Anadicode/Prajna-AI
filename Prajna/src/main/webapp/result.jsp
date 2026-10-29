<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>

<%
    String analysis = (String) request.getAttribute("analysis");

    if (analysis == null || analysis.isBlank()) {
        analysis = "No resume analysis is available. Please analyze your resume first.";
    }

    String safeAnalysis = StringEscapeUtils.escapeHtml4(analysis);
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Resume Analysis | Prajna AI</title>

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

:root {
    --bg: #080b14;
    --card: #111827;
    --border: #283349;
    --text: #e2e8f0;
    --muted: #94a3b8;
    --purple: #8b5cf6;
    --cyan: #22d3ee;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background:
        radial-gradient(ellipse at 10% 0%, #1e1740 0%, transparent 38%),
        radial-gradient(ellipse at 90% 15%, #102a3b 0%, transparent 32%),
        var(--bg);
    color: var(--text);
    min-height: 100vh;
    padding: 35px 18px;
    line-height: 1.7;
}

.container {
    max-width: 1050px;
    margin: auto;
}

/* Navigation */

.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 32px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 22px;
    font-weight: 800;
    letter-spacing: -0.5px;
}

.brand-icon {
    display: grid;
    place-items: center;
    width: 44px;
    height: 44px;
    border-radius: 13px;
    background: linear-gradient(135deg, #8b5cf6, #4f46e5);
    color: white;
    font-size: 23px;
    box-shadow: 0 5px 25px #8b5cf633;
}

.brand span {
    color: #a78bfa;
}

.nav-label {
    color: #a5b4fc;
    border: 1px solid #38345f;
    background: #17152b;
    border-radius: 30px;
    padding: 7px 13px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 1px;
}

/* Hero */

.hero {
    padding: 36px;
    background: linear-gradient(120deg, #241b49, #151d32 70%);
    border: 1px solid #403568;
    border-radius: 22px 22px 0 0;
    position: relative;
    overflow: hidden;
}

.hero::after {
    content: "✦";
    position: absolute;
    right: 45px;
    top: 5px;
    font-size: 115px;
    color: #a78bfa;
    opacity: 0.09;
    pointer-events: none;
}

.eyebrow {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 6px 12px;
    border-radius: 30px;
    background: #34d39916;
    border: 1px solid #34d39935;
    color: #6ee7b7;
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 18px;
}

.dot {
    width: 7px;
    height: 7px;
    background: #34d399;
    border-radius: 50%;
}

.hero h1 {
    font-size: clamp(28px, 4vw, 40px);
    line-height: 1.25;
    color: white;
    letter-spacing: -1px;
    margin-bottom: 12px;
}

.hero h1 span {
    color: #a78bfa;
}

.hero p {
    max-width: 650px;
    color: #b8c3d7;
    font-size: 14px;
}

.hero-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 22px;
}

.tag {
    background: #0b1020a8;
    border: 1px solid #ffffff17;
    border-radius: 8px;
    padding: 7px 11px;
    font-size: 12px;
    color: #d1d5db;
}

/* Main card */

.main-card {
    background: #101827;
    border: 1px solid var(--border);
    border-top: none;
    border-radius: 0 0 22px 22px;
    box-shadow: 0 25px 80px #00000030;
    overflow: hidden;
}

.card-header {
    padding: 24px 30px;
    border-bottom: 1px solid var(--border);
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
}

.header-left {
    display: flex;
    align-items: center;
    gap: 13px;
}

.header-icon {
    width: 45px;
    height: 45px;
    display: grid;
    place-items: center;
    flex-shrink: 0;
    border-radius: 12px;
    background: #8b5cf620;
    border: 1px solid #8b5cf640;
    color: #c4b5fd;
    font-size: 23px;
}

.card-header h2 {
    font-size: 17px;
    color: white;
}

.card-header p {
    font-size: 12px;
    color: var(--muted);
}

.ready-badge {
    padding: 6px 11px;
    color: #6ee7b7;
    background: #10b98113;
    border: 1px solid #10b98130;
    border-radius: 8px;
    font-size: 11px;
    font-weight: 700;
}

/* Analysis area */

.analysis-area {
    padding: 30px;
}

.analysis-label {
    display: flex;
    align-items: center;
    gap: 9px;
    margin-bottom: 20px;
    color: #a5b4fc;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.5px;
    text-transform: uppercase;
}

.analysis-label::before {
    content: "";
    width: 4px;
    height: 17px;
    border-radius: 5px;
    background: linear-gradient(#a78bfa, #22d3ee);
}

/* Dynamic content container */

#analysisContent {
    color: #dbe4f0;
    font-size: 14px;
    line-height: 1.9;
    overflow-wrap: anywhere;
}

/* Automatically styled headings */

#analysisContent h3 {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 16px;
    color: #f1f5f9;
    margin: 30px 0 14px;
    padding: 13px 16px;
    background: linear-gradient(90deg, #8b5cf615, #11182700);
    border-left: 3px solid var(--purple);
    border-radius: 0 9px 9px 0;
}

#analysisContent h3:first-child {
    margin-top: 0;
}

#analysisContent h3::before {
    content: "✧";
    color: #a78bfa;
    font-size: 18px;
}

#analysisContent p {
    margin: 9px 0;
    color: #cbd5e1;
}

/* Bullet lists */

#analysisContent ul {
    list-style: none;
    margin: 12px 0 20px;
    padding: 0;
}

#analysisContent li {
    position: relative;
    padding: 11px 14px 11px 35px;
    margin: 8px 0;
    background: #172033;
    border: 1px solid #29364b;
    border-radius: 10px;
    color: #d3ddec;
    transition: border-color 0.2s, transform 0.2s;
}

#analysisContent li::before {
    content: "✓";
    position: absolute;
    left: 13px;
    top: 11px;
    color: #a78bfa;
    font-weight: 800;
}

#analysisContent li:hover {
    border-color: #6554a8;
    transform: translateX(3px);
}

/* Emphasis */

#analysisContent strong {
    color: #c4b5fd;
    font-weight: 700;
}

#analysisContent .score-card {
    margin-bottom: 24px;
    padding: 20px;
    background: linear-gradient(120deg, #31215b, #17233c);
    border: 1px solid #6554a855;
    border-radius: 15px;
}

#analysisContent .score-label {
    color: #c4b5fd;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
}

#analysisContent .score-value {
    display: block;
    font-size: 34px;
    font-weight: 800;
    color: white;
    line-height: 1.4;
    margin-top: 3px;
}

/* Actions */

.actions {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    padding: 22px 30px;
    border-top: 1px solid var(--border);
    background: #080d18;
}

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    padding: 12px 19px;
    border-radius: 10px;
    border: 1px solid transparent;
    font-family: inherit;
    font-size: 13px;
    font-weight: 700;
    text-decoration: none;
    cursor: pointer;
    transition: 0.2s ease;
}

.btn:hover {
    transform: translateY(-2px);
}

.btn-primary {
    color: white;
    background: linear-gradient(100deg, #7c3aed, #6366f1);
    box-shadow: 0 5px 20px #6366f128;
}

.btn-primary:hover {
    filter: brightness(1.12);
}

.btn-secondary {
    color: #dbe4f0;
    background: #172033;
    border-color: #334155;
}

.btn-secondary:hover {
    background: #243047;
}

/* Footer */

.footer {
    margin-top: 23px;
    text-align: center;
    color: #718096;
    font-size: 12px;
}

.footer strong {
    color: #a78bfa;
}

/* Mobile */

@media (max-width: 600px) {
    body {
        padding: 20px 12px;
    }

    .navbar {
        align-items: flex-start;
    }

    .brand {
        font-size: 19px;
    }

    .nav-label {
        font-size: 9px;
        letter-spacing: 0.4px;
    }

    .hero {
        padding: 25px 20px;
    }

    .hero::after {
        right: 12px;
        font-size: 75px;
    }

    .card-header {
        padding: 20px;
    }

    .ready-badge {
        display: none;
    }

    .analysis-area {
        padding: 20px;
    }

    .actions {
        padding: 20px;
    }

    .btn {
        width: 100%;
    }

    #analysisContent h3 {
        font-size: 14px;
    }
}

/* Print */

@media print {
    @page {
        margin: 15mm;
    }

    body {
        background: white !important;
        color: #111827;
        padding: 0;
    }

    .navbar, .actions, .footer {
        display: none !important;
    }

    .hero {
        border-radius: 12px 12px 0 0;
    }

    .main-card {
        box-shadow: none;
        border-radius: 0 0 12px 12px;
    }

    #analysisContent,
    #analysisContent p,
    #analysisContent li {
        color: #1f2937;
    }

    #analysisContent li {
        background: white;
        border-color: #ddd;
    }

    #analysisContent h3 {
        color: #111827;
        break-after: avoid;
    }
}
</style>
</head>

<body>
<div class="container">

    <nav class="navbar">
        <div class="brand">
            <div class="brand-icon">✦</div>
            <div>Prajna <span>AI</span></div>
        </div>

        <div class="nav-label">INTELLIGENT RESUME ANALYSIS</div>
    </nav>

    <header class="hero">
        <div class="eyebrow">
            <span class="dot"></span>
            Analysis Complete
        </div>

        <h1>Your Resume, <span>Decoded.</span></h1>

        <p>
            Discover your strengths, identify skill gaps, evaluate
            resume structure, and get practical recommendations to
            improve your next job application.
        </p>

        <div class="hero-tags">
            <div class="tag">✧ AI-Powered Feedback</div>
            <div class="tag">▤ Resume Review</div>
            <div class="tag">↗ Career Insights</div>
        </div>
    </header>

    <main class="main-card">

        <div class="card-header">
            <div class="header-left">
                <div class="header-icon">✧</div>
                <div>
                    <h2>Your Resume Feedback</h2>
                    <p>Personalized insights and improvement suggestions</p>
                </div>
            </div>

            <div class="ready-badge">✓ Report Ready</div>
        </div>

        <section class="analysis-area">
            <div class="analysis-label">AI Analysis Report</div>

            <div id="analysisContent"><%= safeAnalysis %></div>
        </section>

        <div class="actions">
            <a class="btn btn-primary"
               href="<%= request.getContextPath() %>/">
                ↻ Analyze Another Resume
            </a>

            <button type="button"
                    class="btn btn-secondary"
                    onclick="window.print()">
                ↓ Print / Save as PDF
            </button>
        </div>

    </main>

    <footer class="footer">
        Powered by <strong>Prajna AI</strong>
        <br>
        AI-generated feedback may contain errors. Verify recommendations
        before making career decisions.
    </footer>

</div>

<script>
(function () {
    const container = document.getElementById("analysisContent");

    if (!container) {
        return;
    }

    // Read the already HTML-escaped response as plain text.
    // Do not insert the AI response using innerHTML.
    const rawText = container.textContent || "";
    const lines = rawText.split(/\r?\n/);

    const fragment = document.createDocumentFragment();
    let currentList = null;
    let scoreAdded = false;

    const headingPattern =
        /^(?:#{1,6}\s*)?(?:\d+[\).]\s*)?(?:\*\*)?(?:overall\s+)?(?:resume\s+)?(?:ats\s+score|score|resume\s+summary|summary|overall\s+assessment|strengths|key\s+strengths|technical\s+skills|skills|missing\s+skills|skill\s+gaps|weaknesses|areas\s+for\s+improvement|improvements|recommendations|actionable\s+recommendations|suggestions|suitable\s+job\s+roles|job\s+roles|job\s+match|ats\s+compatibility|ats\s+evaluation|format\s+and\s+structure|education|experience|projects|conclusion|final\s+verdict|keywords)(?:\*\*)?\s*:?\s*$/i;

    const scorePattern =
        /(?:ATS\s+(?:compatibility\s+)?score|resume\s+score|overall\s+score)\s*[:\-–]?\s*(\d{1,3})(?:\s*\/\s*100|\s*%)?/i;

    function addParagraph(text) {
        if (!text.trim()) {
            return;
        }

        const p = document.createElement("p");
        p.textContent = text.trim();
        fragment.appendChild(p);
    }

    function flushList() {
        currentList = null;
    }

    function addHeading(text) {
        flushList();

        const h = document.createElement("h3");
        h.textContent = text
            .replace(/^#{1,6}\s*/, "")
            .replace(/^\d+[\).]\s*/, "")
            .replace(/\*\*/g, "")
            .replace(/:$/, "")
            .trim();

        fragment.appendChild(h);
    }

    function addScore(score) {
        if (scoreAdded || score < 0 || score > 100) {
            return;
        }

        scoreAdded = true;

        const card = document.createElement("div");
        card.className = "score-card";

        const label = document.createElement("div");
        label.className = "score-label";
        label.textContent = "Resume / ATS Score";

        const value = document.createElement("span");
        value.className = "score-value";
        value.textContent = score + "/100";

        card.appendChild(label);
        card.appendChild(value);

        fragment.appendChild(card);
    }

    lines.forEach(function (originalLine) {
        const line = originalLine.trim();

        if (!line) {
            flushList();
            return;
        }

        // Recognize common heading formats.
        if (headingPattern.test(line)) {
            addHeading(line);
            return;
        }

        // Recognize Markdown headings even when the heading is
        // not one of the known section names.
        if (/^#{1,6}\s+/.test(line)) {
            addHeading(line);
            return;
        }

        // Recognize standalone ATS score lines.
        const scoreMatch = line.match(scorePattern);

        if (scoreMatch) {
            const score = Number(scoreMatch[1]);

            if (score >= 0 && score <= 100) {
                addScore(score);
            }

            addParagraph(line);
            return;
        }

        // Recognize Markdown bold headings such as **Strengths:**
        const boldHeading = line.match(/^\*\*(.{1,100}?)\*\*\s*:?\s*$/);

        if (boldHeading) {
            addHeading(boldHeading[1]);
            return;
        }

        // Recognize bullets and numbered recommendations.
        const bulletMatch = line.match(
            /^(?:[-*•▪]|\d+[.)])\s+(.+)$/
        );

        if (bulletMatch) {
            if (!currentList) {
                currentList = document.createElement("ul");
                fragment.appendChild(currentList);
            }

            const li = document.createElement("li");
            li.textContent = bulletMatch[1]
                .replace(/\*\*(.*?)\*\*/g, "$1");

            currentList.appendChild(li);
            return;
        }

        flushList();
        addParagraph(line.replace(/\*\*(.*?)\*\*/g, "$1"));
    });

    // The response remains plain text. All elements are created
    // using DOM methods and AI content is assigned with textContent.
    container.replaceChildren(fragment);
})();
</script>

</body>
</html>

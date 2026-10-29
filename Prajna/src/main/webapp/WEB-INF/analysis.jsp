
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="org.apache.commons.text.StringEscapeUtils" %>

<%
    String analysis = (String) request.getAttribute("analysis");

    if (analysis == null || analysis.isBlank()) {
        analysis = "No resume analysis is available. Please analyze your resume first.";
    }
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
            --panel: #111827;
            --panel-light: #172033;
            --border: #263249;
            --text: #e5e7eb;
            --muted: #94a3b8;
            --primary: #8b5cf6;
            --secondary: #6366f1;
            --accent: #22d3ee;
        }

        body {
            font-family: Inter, "Segoe UI", Arial, sans-serif;
            background:
                radial-gradient(ellipse at top left,
                    rgba(99, 102, 241, 0.14), transparent 40%),
                radial-gradient(ellipse at top right,
                    rgba(139, 92, 246, 0.10), transparent 35%),
                var(--bg);
            color: var(--text);
            min-height: 100vh;
            padding: 42px 20px;
            line-height: 1.8;
        }

        .container {
            max-width: 1050px;
            margin: 0 auto;
        }

        /* Top navigation */

        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 30px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .brand-icon {
            display: grid;
            place-items: center;
            width: 43px;
            height: 43px;
            border-radius: 13px;
            background: linear-gradient(135deg, #8b5cf6, #4f46e5);
            color: white;
            font-size: 22px;
            box-shadow: 0 5px 24px rgba(139, 92, 246, 0.25);
        }

        .brand span {
            color: #a78bfa;
        }

        .top-label {
            color: var(--muted);
            font-size: 12px;
            padding: 7px 12px;
            border: 1px solid var(--border);
            border-radius: 30px;
            background: rgba(17, 24, 39, 0.7);
        }

        /* Header */

        .hero {
            position: relative;
            overflow: hidden;
            padding: 38px;
            border: 1px solid #38345f;
            border-radius: 22px 22px 0 0;
            background:
                linear-gradient(115deg,
                    rgba(91, 33, 182, 0.35),
                    rgba(30, 41, 59, 0.96) 70%),
                var(--panel);
        }

        .hero::after {
            content: "";
            position: absolute;
            width: 230px;
            height: 230px;
            right: -70px;
            top: -100px;
            border-radius: 50%;
            background: rgba(139, 92, 246, 0.12);
            filter: blur(2px);
            pointer-events: none;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #c4b5fd;
            background: rgba(139, 92, 246, 0.13);
            border: 1px solid rgba(167, 139, 250, 0.25);
            padding: 5px 11px;
            border-radius: 30px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            margin-bottom: 17px;
        }

        .status-dot {
            width: 7px;
            height: 7px;
            background: #34d399;
            border-radius: 50%;
            box-shadow: 0 0 10px rgba(52, 211, 153, 0.6);
        }

        .hero h1 {
            font-size: clamp(27px, 4vw, 39px);
            line-height: 1.25;
            letter-spacing: -1.2px;
            margin-bottom: 12px;
            color: #ffffff;
        }

        .hero h1 span {
            background: linear-gradient(90deg, #c4b5fd, #67e8f9);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .hero p {
            color: #b7c2d5;
            max-width: 610px;
            font-size: 14px;
        }

        .hero-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 23px;
        }

        .meta-item {
            color: #cbd5e1;
            background: rgba(8, 11, 20, 0.35);
            border: 1px solid rgba(148, 163, 184, 0.18);
            border-radius: 9px;
            padding: 8px 12px;
            font-size: 12px;
        }

        /* Main analysis panel */

        .result-card {
            background: rgba(17, 24, 39, 0.96);
            border: 1px solid var(--border);
            border-top: none;
            border-radius: 0 0 22px 22px;
            box-shadow: 0 24px 70px rgba(0, 0, 0, 0.25);
        }

        .section-heading {
            padding: 25px 32px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }

        .heading-left {
            display: flex;
            align-items: center;
            gap: 13px;
        }

        .heading-icon {
            width: 43px;
            height: 43px;
            display: grid;
            place-items: center;
            flex-shrink: 0;
            border-radius: 12px;
            background: rgba(99, 102, 241, 0.14);
            border: 1px solid rgba(129, 140, 248, 0.2);
            font-size: 21px;
        }

        .section-heading h2 {
            color: #f8fafc;
            font-size: 17px;
            line-height: 1.5;
        }

        .section-heading p {
            color: var(--muted);
            font-size: 12px;
        }

        .result-badge {
            flex-shrink: 0;
            padding: 6px 10px;
            border-radius: 8px;
            background: rgba(16, 185, 129, 0.10);
            color: #6ee7b7;
            border: 1px solid rgba(52, 211, 153, 0.20);
            font-size: 11px;
            font-weight: 700;
        }

        /* AI response */

        .analysis-wrapper {
            padding: 32px;
        }

        .analysis-label {
            color: #a5b4fc;
            text-transform: uppercase;
            letter-spacing: 1.3px;
            font-size: 11px;
            font-weight: 800;
            margin-bottom: 16px;
        }

        .analysis-content {
            color: #d6deeb;
            font-size: 15px;
            line-height: 2;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            font-family: inherit;
            background: linear-gradient(
                135deg,
                rgba(23, 32, 51, 0.8),
                rgba(15, 23, 42, 0.55)
            );
            border: 1px solid #27344a;
            border-radius: 15px;
            padding: 26px;
        }

        /* Action buttons */

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            padding: 22px 32px;
            border-top: 1px solid var(--border);
            background: rgba(8, 11, 20, 0.25);
            border-radius: 0 0 22px 22px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            text-decoration: none;
            padding: 12px 19px;
            border-radius: 10px;
            font-family: inherit;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            border: 1px solid transparent;
            transition: transform 0.2s ease,
                        background 0.2s ease,
                        border-color 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-primary {
            background: linear-gradient(100deg, #7c3aed, #6366f1);
            color: #ffffff;
            box-shadow: 0 5px 18px rgba(99, 102, 241, 0.18);
        }

        .btn-primary:hover {
            background: linear-gradient(100deg, #6d28d9, #4f46e5);
        }

        .btn-secondary {
            background: #172033;
            color: #dbe4f0;
            border-color: #334155;
        }

        .btn-secondary:hover {
            background: #202b40;
            border-color: #64748b;
        }

        /* Footer */

        .footer {
            text-align: center;
            margin-top: 23px;
            color: #718096;
            font-size: 12px;
            line-height: 1.8;
        }

        .footer strong {
            color: #a5b4fc;
            font-weight: 600;
        }

        /* Responsive layout */

        @media (max-width: 600px) {
            body {
                padding: 22px 12px;
            }

            .topbar {
                align-items: flex-start;
            }

            .brand {
                font-size: 18px;
            }

            .top-label {
                font-size: 10px;
            }

            .hero {
                padding: 25px 21px;
            }

            .hero h1 {
                letter-spacing: -0.6px;
            }

            .section-heading {
                padding: 20px;
                align-items: flex-start;
            }

            .section-heading h2 {
                font-size: 15px;
            }

            .result-badge {
                display: none;
            }

            .analysis-wrapper {
                padding: 20px;
            }

            .analysis-content {
                padding: 18px;
                font-size: 14px;
                line-height: 1.9;
            }

            .actions {
                padding: 20px;
            }

            .btn {
                width: 100%;
            }
        }

        /* Print / save as PDF */

        @media print {
            @page {
                margin: 18mm;
            }

            body {
                background: #ffffff !important;
                color: #111827;
                padding: 0;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
            }

            .topbar,
            .actions,
            .footer {
                display: none !important;
            }

            .hero {
                border-radius: 12px 12px 0 0;
            }

            .result-card {
                box-shadow: none;
                border-radius: 0 0 12px 12px;
            }

            .analysis-content {
                color: #1f2937;
                background: #ffffff;
                border-color: #d1d5db;
            }

            .section-heading h2 {
                color: #111827;
            }

            .analysis-wrapper {
                padding: 20px;
            }
        }
    </style>
</head>

<body>
<div class="container">

    <nav class="topbar">
        <div class="brand">
            <div class="brand-icon">✦</div>
            <div>Prajna <span>AI</span></div>
        </div>

        <div class="top-label">AI-POWERED CAREER TOOLS</div>
    </nav>

    <header class="hero">
        <div class="eyebrow">
            <span class="status-dot"></span>
            Analysis Complete
        </div>

        <h1>Your Resume, <span>Decoded.</span></h1>

        <p>
            Get a clearer picture of your resume's strengths, identify
            opportunities for improvement, and discover practical ways
            to make your next application stronger.
        </p>

        <div class="hero-meta">
            <div class="meta-item">✦ AI-Powered Insights</div>
            <div class="meta-item">▤ Resume Evaluation</div>
            <div class="meta-item">↗ Career Improvement</div>
        </div>
    </header>

    <main class="result-card">

        <div class="section-heading">
            <div class="heading-left">
                <div class="heading-icon">✧</div>

                <div>
                    <h2>Your Resume Feedback</h2>
                    <p>Personalized analysis and recommendations</p>
                </div>
            </div>

            <div class="result-badge">✓ Result Ready</div>
        </div>

        <section class="analysis-wrapper">
            <div class="analysis-label">AI Analysis Report</div>

            <div class="analysis-content"><%= StringEscapeUtils.escapeHtml4(analysis) %></div>
        </section>

        <div class="actions">
            <a class="btn btn-primary"
               href="<%= request.getContextPath() %>/resume.jsp">
                ↻ &nbsp; Analyze Another Resume
            </a>

            <button type="button"
                    class="btn btn-secondary"
                    onclick="window.print()">
                ↓ &nbsp; Print / Save as PDF
            </button>
        </div>

    </main>

    <footer class="footer">
        Powered by <strong>Prajna AI</strong> · Your next opportunity starts with a stronger resume.
        <br>
        AI-generated feedback may contain errors. Verify recommendations before making career decisions.
    </footer>

</div>
</body>
</html>

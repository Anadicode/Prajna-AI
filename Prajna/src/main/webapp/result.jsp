
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

    <title>Resume Analysis | AI Resume Analyser</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f3f4f6;
            color: #1f2937;
            line-height: 1.7;
            padding: 30px 16px;
        }

        .container {
            max-width: 950px;
            margin: 0 auto;
        }

        .header {
            background: #111827;
            color: white;
            padding: 28px;
            border-radius: 14px 14px 0 0;
        }

        .header h1 {
            font-size: 28px;
            margin-bottom: 6px;
        }

        .header p {
            color: #d1d5db;
            font-size: 14px;
        }

        .result-card {
            background: white;
            padding: 30px;
            border-radius: 0 0 14px 14px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.06);
        }

        .status {
            display: inline-block;
            padding: 5px 12px;
            margin-bottom: 20px;
            background: #dcfce7;
            color: #166534;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        .result-title {
            font-size: 21px;
            margin-bottom: 16px;
            color: #111827;
        }

        .analysis-content {
            white-space: pre-wrap;
            overflow-wrap: anywhere;
            font-family: inherit;
            font-size: 15px;
            color: #374151;
            line-height: 1.9;
        }

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 28px;
        }

        .btn {
            display: inline-block;
            text-decoration: none;
            padding: 11px 18px;
            border-radius: 8px;
            font-weight: bold;
            font-size: 14px;
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #1f2937;
        }

        .footer {
            text-align: center;
            margin-top: 20px;
            color: #6b7280;
            font-size: 12px;
        }

        @media (max-width: 600px) {
            body {
                padding: 16px 10px;
            }

            .header, .result-card {
                padding: 20px;
            }

            .header h1 {
                font-size: 23px;
            }
        }

        @media print {
            body {
                background: white;
                padding: 0;
            }

            .actions, .footer {
                display: none;
            }

            .header, .result-card {
                box-shadow: none;
                border-radius: 0;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <header class="header">
        <h1>AI Resume Analysis</h1>
        <p>Personalized feedback powered by your AI resume analyser</p>
    </header>

    <main class="result-card">

        <span class="status">Analysis Result</span>

        <h2 class="result-title">Your Resume Feedback</h2>

        <div class="analysis-content"><%= 
            StringEscapeUtils.escapeHtml4(analysis)
        %></div>

        <div class="actions">
            <a class="btn btn-primary"
               href="<%= request.getContextPath() %>/index.jsp">
                Analyze Another Resume
            </a>

            <button class="btn btn-secondary"
                    onclick="window.print()">
                Print / Save as PDF
            </button>
        </div>

    </main>

    <footer class="footer">
        AI-generated feedback may contain errors. Review recommendations before making career decisions.
    </footer>

</div>

</body>
</html>

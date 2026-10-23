<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'LifeCare Hospital Management & Billing System'}</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-navy: #0f2b48;
            --primary-blue: #1a56db;
            --accent-teal: #0d9488;
            --medical-green: #10b981;
            --light-bg: #f8fafc;
            --card-border: #e2e8f0;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--light-bg);
            color: #334155;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .navbar-custom {
            background: linear-gradient(135deg, #0f2b48 0%, #1e3a8a 100%);
            box-shadow: 0 4px 12px rgba(15, 43, 72, 0.15);
        }

        .navbar-custom .navbar-brand {
            font-weight: 700;
            letter-spacing: -0.5px;
            color: #ffffff !important;
            font-size: 1.25rem;
        }

        .navbar-custom .nav-link {
            color: #e2e8f0 !important;
            font-weight: 500;
            padding: 0.5rem 0.9rem !important;
            border-radius: 6px;
            transition: all 0.2s ease-in-out;
        }

        .navbar-custom .nav-link:hover,
        .navbar-custom .nav-link.active {
            background-color: rgba(255, 255, 255, 0.15);
            color: #ffffff !important;
        }

        .card-custom {
            border: 1px solid var(--card-border);
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            background-color: #ffffff;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .card-custom:hover {
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
        }

        .stat-card {
            border-left: 4px solid var(--primary-blue);
            padding: 1.25rem;
        }

        .badge-status-paid {
            background-color: #dcfce7;
            color: #15803d;
            font-weight: 600;
        }

        .badge-status-unpaid {
            background-color: #fee2e2;
            color: #b91c1c;
            font-weight: 600;
        }

        .badge-status-partial {
            background-color: #fef3c7;
            color: #b45309;
            font-weight: 600;
        }

        .badge-status-completed {
            background-color: #e0f2fe;
            color: #0369a1;
            font-weight: 600;
        }

        .table-custom th {
            background-color: #f1f5f9;
            color: #475569;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.78rem;
            letter-spacing: 0.5px;
            border-top: none;
        }

        .content-wrapper {
            flex: 1 0 auto;
            padding-bottom: 3rem;
        }

        .footer-custom {
            background-color: #ffffff;
            border-top: 1px solid var(--card-border);
            padding: 1.25rem 0;
            font-size: 0.85rem;
            color: #64748b;
        }

        @media print {
            .no-print {
                display: none !important;
            }
            body {
                background-color: #ffffff;
            }
            .card-custom {
                border: none;
                box-shadow: none;
            }
        }
    </style>
</head>
<body>

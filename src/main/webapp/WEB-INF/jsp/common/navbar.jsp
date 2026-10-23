<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom no-print sticky-top py-2">
    <div class="container-fluid px-4">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/dashboard">
            <span class="d-inline-flex align-items-center justify-content-center bg-white text-primary rounded-circle" style="width: 36px; height: 36px;">
                <i class="fa-solid fa-hospital-user text-primary fs-5"></i>
            </span>
            <span>
                <span class="d-block fw-bold" style="line-height: 1.1;">LifeCare Hospital</span>
                <small class="text-white-50 fw-normal" style="font-size: 0.72rem;">Billing & Patient Management</small>
            </span>
        </a>

        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3 gap-1">
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
                        <i class="fa-solid fa-chart-line me-1"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'patients' ? 'active' : ''}" href="${pageContext.request.contextPath}/patients">
                        <i class="fa-solid fa-user-injured me-1"></i> Patients
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'consultations' ? 'active' : ''}" href="${pageContext.request.contextPath}/consultations">
                        <i class="fa-solid fa-user-doctor me-1"></i> Consultations
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'lab' ? 'active' : ''}" href="${pageContext.request.contextPath}/lab">
                        <i class="fa-solid fa-microscope me-1"></i> Laboratory
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'billing' ? 'active' : ''}" href="${pageContext.request.contextPath}/billing">
                        <i class="fa-solid fa-file-invoice-dollar me-1"></i> Billing & Invoices
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'aop' ? 'active' : ''}" href="${pageContext.request.contextPath}/aop-monitor">
                        <i class="fa-solid fa-shield-halved me-1 text-warning"></i> AOP Monitor
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/patients/register" class="btn btn-sm btn-light text-primary fw-semibold shadow-sm">
                    <i class="fa-solid fa-user-plus me-1"></i> New Patient
                </a>
                <a href="${pageContext.request.contextPath}/billing/new" class="btn btn-sm btn-success fw-semibold shadow-sm">
                    <i class="fa-solid fa-receipt me-1"></i> New Bill
                </a>
            </div>
        </div>
    </div>
</nav>

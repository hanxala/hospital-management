<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Patients Directory - LifeCare Hospital" />
<c:set var="activePage" value="patients" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid px-4 py-4">
        <!-- Breadcrumb / Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1 text-dark">
                    <i class="fa-solid fa-hospital-user text-primary me-2"></i>Patient Management Directory
                </h3>
                <p class="text-muted mb-0">Centralized patient records, registrations, histories, and clinical activity.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/patients/register" class="btn btn-primary shadow-sm">
                    <i class="fa-solid fa-user-plus me-1"></i> Register New Patient
                </a>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Search Card -->
        <div class="card card-custom mb-4">
            <div class="card-body p-3">
                <form action="${pageContext.request.contextPath}/patients" method="get" class="row g-2 align-items-center">
                    <div class="col-md-9">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="fa-solid fa-magnifying-glass text-muted"></i>
                            </span>
                            <input type="text" name="search" class="form-control border-start-0"
                                   placeholder="Search patients by UHID (e.g. UHID-1001), First Name, Last Name, or Phone..."
                                   value="${searchQuery}">
                        </div>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary flex-grow-1">
                            <i class="fa-solid fa-filter me-1"></i> Search
                        </button>
                        <c:if test="${not empty searchQuery}">
                            <a href="${pageContext.request.contextPath}/patients" class="btn btn-outline-secondary">Reset</a>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>

        <!-- Patients Table Card -->
        <div class="card card-custom">
            <div class="card-header bg-transparent py-3 d-flex justify-content-between align-items-center">
                <span class="fw-bold text-dark">
                    Registered Patients (${patients.size()})
                </span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>UHID</th>
                                <th>Patient Name</th>
                                <th>Age / Gender</th>
                                <th>Blood Group</th>
                                <th>Contact Phone</th>
                                <th>Reg. Date</th>
                                <th>Status</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${patients}">
                                <tr>
                                    <td>
                                        <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                            ${p.patientUhid}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/patients/view/${p.id}" class="fw-bold text-dark text-decoration-none hover-primary">
                                            ${p.fullName}
                                        </a>
                                        <div class="text-muted" style="font-size: 0.78rem;">${p.email}</div>
                                    </td>
                                    <td>
                                        ${p.age} Yrs / <span class="badge bg-light text-dark border">${p.gender}</span>
                                    </td>
                                    <td>
                                        <span class="badge bg-danger-subtle text-danger fw-bold">${p.bloodGroup}</span>
                                    </td>
                                    <td>
                                        <i class="fa-solid fa-phone text-muted me-1" style="font-size: 0.75rem;"></i>${p.phone}
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${p.registrationDate}" pattern="dd-MMM-yyyy" />
                                    </td>
                                    <td>
                                        <span class="badge ${p.status == 'ACTIVE' ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'}">
                                            ${p.status}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/patients/view/${p.id}" class="btn btn-outline-primary" title="View Patient Profile">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/patients/edit/${p.id}" class="btn btn-outline-secondary" title="Edit Patient Details">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/consultations/new?patientId=${p.id}" class="btn btn-outline-info" title="Consult Doctor">
                                                <i class="fa-solid fa-stethoscope"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/billing/new?patientId=${p.id}" class="btn btn-outline-success" title="Generate Bill">
                                                <i class="fa-solid fa-receipt"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty patients}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-user-slash fs-2 d-block mb-2 text-secondary"></i>
                                        No patient records found matching your query.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="common/footer.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Select Patient for Billing - LifeCare Hospital" />
<c:set var="activePage" value="billing" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold text-dark mb-1">
                            <i class="fa-solid fa-file-invoice text-primary me-2"></i>Generate Patient Bill
                        </h3>
                        <p class="text-muted mb-0">Select a registered patient to auto-fetch unbilled doctor consultations and laboratory charges.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/billing" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back
                    </a>
                </div>

                <div class="card card-custom p-4">
                    <form action="${pageContext.request.contextPath}/billing/new" method="get">
                        <div class="mb-4">
                            <label class="form-label fw-semibold">Choose Patient <span class="text-danger">*</span></label>
                            <select name="patientId" class="form-select form-select-lg" required>
                                <option value="" disabled selected>-- Select Patient by UHID or Name --</option>
                                <c:forEach var="p" items="${patients}">
                                    <option value="${p.id}">
                                        ${p.patientUhid} - ${p.fullName} (${p.gender}, ${p.age} Yrs) - Phone: ${p.phone}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="form-text mt-2">
                                <i class="fa-solid fa-circle-info text-primary me-1"></i>
                                All pending outpatient consultations and laboratory test investigations for this patient will be aggregated automatically into a consolidated invoice.
                            </div>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/billing" class="btn btn-light px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="fa-solid fa-arrow-right me-1"></i> Proceed to Billing Details
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

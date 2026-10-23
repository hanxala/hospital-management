<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Order Lab Test - LifeCare Hospital" />
<c:set var="activePage" value="lab" />
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
                            <i class="fa-solid fa-vial-circle-check text-primary me-2"></i>Order Diagnostic Investigation
                        </h3>
                        <p class="text-muted mb-0">Select diagnostic tests from catalog and record charges for billing integration.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/lab" class="btn btn-outline-secondary">
                        <i class="fa-solid fa-arrow-left me-1"></i> Back
                    </a>
                </div>

                <div class="card card-custom p-4">
                    <form action="${pageContext.request.contextPath}/lab/order" method="post">
                        <div class="row g-3">
                            <!-- Select Patient -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Patient <span class="text-danger">*</span></label>
                                <select name="patientId" class="form-select" required>
                                    <option value="" disabled ${empty order.patientId ? 'selected' : ''}>-- Select Patient --</option>
                                    <c:forEach var="p" items="${patients}">
                                        <option value="${p.id}" ${order.patientId == p.id ? 'selected' : ''}>
                                            ${p.patientUhid} - ${p.fullName} (${p.gender}, ${p.age} yrs)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Select Lab Test -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Diagnostic Test <span class="text-danger">*</span></label>
                                <select name="testId" id="testSelect" class="form-select" required onchange="updateLabFee()">
                                    <option value="" disabled selected>-- Select Investigation --</option>
                                    <c:forEach var="t" items="${testCatalog}">
                                        <option value="${t.id}" data-fee="${t.standardFee}">
                                            ${t.testName} [${t.category}] - ₹${t.standardFee}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Referring Doctor -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Referring Doctor</label>
                                <select name="doctorId" class="form-select">
                                    <option value="">-- Optional / Self-Ordered --</option>
                                    <c:forEach var="d" items="${doctors}">
                                        <option value="${d.id}">
                                            ${d.name} (${d.specialization})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Lab Fee -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Investigation Charge (₹) <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text">₹</span>
                                    <input type="number" step="0.01" name="labFee" id="labFeeInput"
                                           class="form-control" value="350.00" required>
                                </div>
                                <div class="form-text">Standard catalog tariff auto-applied.</div>
                            </div>

                            <!-- Initial Status -->
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Initial Status</label>
                                <select name="status" class="form-select">
                                    <option value="PENDING" selected>PENDING (Specimen Collection / In-Process)</option>
                                    <option value="COMPLETED">COMPLETED (Result Ready)</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Clinical Notes / Reason for Investigation</label>
                                <textarea name="resultSummary" class="form-control" rows="3"
                                          placeholder="Routine preoperative workup / Diagnostic screening..."></textarea>
                            </div>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/lab" class="btn btn-light px-4">Cancel</a>
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="fa-solid fa-check me-1"></i> Confirm & Place Order
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function updateLabFee() {
    var select = document.getElementById("testSelect");
    var selectedOption = select.options[select.selectedIndex];
    var fee = selectedOption.getAttribute("data-fee");
    if (fee) {
        document.getElementById("labFeeInput").value = fee;
    }
}
</script>

<jsp:include page="common/footer.jsp" />

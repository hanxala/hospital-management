<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Laboratory Tests & Investigations - LifeCare Hospital" />
<c:set var="activePage" value="lab" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="content-wrapper">
    <div class="container-fluid px-4 py-4">
        <!-- Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
            <div>
                <h3 class="fw-bold mb-1 text-dark">
                    <i class="fa-solid fa-microscope text-primary me-2"></i>Diagnostic Laboratory & Investigations
                </h3>
                <p class="text-muted mb-0">Manage diagnostic laboratory tests, record specimen test findings, and capture lab charges.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/lab/order" class="btn btn-primary shadow-sm">
                    <i class="fa-solid fa-vial-circle-check me-1"></i> Order Laboratory Test
                </a>
            </div>
        </div>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Orders Table Card -->
        <div class="card card-custom mb-4">
            <div class="card-header bg-transparent py-3">
                <span class="fw-bold text-dark">Recent Lab Test Orders (${orders.size()})</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-custom align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Order Date</th>
                                <th>Patient Details</th>
                                <th>Test Name & Code</th>
                                <th>Category</th>
                                <th>Referring Doctor</th>
                                <th>Results / Diagnostic Findings</th>
                                <th class="text-end">Lab Fee</th>
                                <th class="text-center">Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${o.orderDate}" pattern="dd-MMM-yyyy, HH:mm" />
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/patients/view/${o.patientId}" class="fw-bold text-dark text-decoration-none">
                                            ${o.patientName}
                                        </a>
                                        <small class="text-muted d-block">${o.patientUhid}</small>
                                    </td>
                                    <td>
                                        <span class="fw-bold">${o.testName}</span>
                                        <span class="badge bg-light text-dark border ms-1">${o.testCode}</span>
                                    </td>
                                    <td>
                                        <span class="badge bg-secondary-subtle text-secondary">${o.testCategory}</span>
                                    </td>
                                    <td>
                                        <span class="text-dark">${o.doctorName}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty o.resultSummary}">
                                                <span class="text-success fw-medium"><i class="fa-solid fa-square-check me-1"></i>${o.resultSummary}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted fst-italic">Awaiting Laboratory Analysis</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end fw-bold text-dark">
                                        ₹<fmt:formatNumber value="${o.labFee}" minFractionDigits="2"/>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge ${o.status == 'COMPLETED' ? 'badge-status-completed' : (o.status == 'BILLED' ? 'bg-primary-subtle text-primary' : 'bg-warning-subtle text-warning')} px-2 py-1">
                                            ${o.status}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <button type="button" class="btn btn-sm btn-outline-primary"
                                                data-bs-toggle="modal" data-bs-target="#resultModal${o.id}"
                                                title="Enter / Update Result">
                                            <i class="fa-solid fa-pen-nib"></i>
                                        </button>

                                        <!-- Update Result Modal -->
                                        <div class="modal fade" id="resultModal${o.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content text-start">
                                                    <form action="${pageContext.request.contextPath}/lab/result/${o.id}" method="post">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title fw-bold">Update Test Result</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <p class="mb-2"><strong>Patient:</strong> ${o.patientName} (${o.patientUhid})</p>
                                                            <p class="mb-3"><strong>Investigation:</strong> ${o.testName} (${o.testCode})</p>

                                                            <div class="mb-3">
                                                                <label class="form-label fw-semibold">Status</label>
                                                                <select name="status" class="form-select">
                                                                    <option value="COMPLETED" selected>COMPLETED</option>
                                                                    <option value="PENDING">PENDING</option>
                                                                </select>
                                                            </div>

                                                            <div class="mb-3">
                                                                <label class="form-label fw-semibold">Diagnostic Findings / Result Summary</label>
                                                                <textarea name="resultSummary" class="form-control" rows="4"
                                                                          placeholder="e.g. Hb: 13.5 g/dL, WBC: 7200 /cumm, Normal Platelet Count" required>${o.resultSummary}</textarea>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                                                            <button type="submit" class="btn btn-primary">Save Result & Mark Complete</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty orders}">
                                <tr>
                                    <td colspan="9" class="text-center py-5 text-muted">
                                        <i class="fa-solid fa-vials fs-2 d-block mb-2 text-secondary"></i>
                                        No laboratory orders placed yet.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Master Lab Catalog Section -->
        <div class="card card-custom">
            <div class="card-header bg-transparent py-3">
                <h6 class="fw-bold mb-0 text-dark">
                    <i class="fa-solid fa-book-medical text-primary me-2"></i>Hospital Diagnostic Test Catalog & Standard Charges
                </h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-sm table-striped align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Test Code</th>
                                <th>Test Name</th>
                                <th>Department Category</th>
                                <th>Clinical Description</th>
                                <th class="text-end">Standard Charge</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${catalog}">
                                <tr>
                                    <td><code>${item.testCode}</code></td>
                                    <td class="fw-semibold text-dark">${item.testName}</td>
                                    <td><span class="badge bg-light text-dark border">${item.category}</span></td>
                                    <td class="text-muted" style="font-size: 0.85rem;">${item.description}</td>
                                    <td class="text-end fw-bold text-dark">₹<fmt:formatNumber value="${item.standardFee}" minFractionDigits="2"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="common/footer.jsp" />

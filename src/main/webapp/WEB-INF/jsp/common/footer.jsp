<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="footer-custom no-print mt-auto">
    <div class="container-fluid px-4">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-center gap-2">
            <div>
                <strong>LifeCare Hospital & Research Institute</strong> &copy; 2026. Built with Spring Boot 3, Spring JDBC, AOP & JSP.
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="badge bg-success-subtle text-success border border-success-subtle">
                    <i class="fa-solid fa-circle-check me-1"></i> System Online
                </span>
                <a href="${pageContext.request.contextPath}/h2-console" target="_blank" class="text-decoration-none text-secondary">
                    <i class="fa-solid fa-database me-1"></i> H2 Database Console
                </a>
                <a href="${pageContext.request.contextPath}/aop-monitor" class="text-decoration-none text-primary">
                    <i class="fa-solid fa-gauge-high me-1"></i> AOP Metrics
                </a>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

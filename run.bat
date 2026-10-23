@echo off
title LifeCare Hospital Billing & Patient Management System
echo =======================================================================
echo   LifeCare Hospital Billing and Patient Management System
echo   Spring Boot + Spring JDBC + Spring AOP + JSP + H2 Database
echo =======================================================================
echo.
echo Starting Application on http://localhost:8080 ...
echo.

set MAVEN_CMD=..\apache-maven-3.9.6\bin\mvn.cmd

if exist "%MAVEN_CMD%" (
    "%MAVEN_CMD%" spring-boot:run
) else (
    mvn spring-boot:run
)

pause

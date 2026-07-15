<?php

declare(strict_types=1);

use OACare\Controllers\AssessmentController;
use OACare\Controllers\EducationController;
use OACare\Controllers\PatientController;

$router->get('/api/v1/health', function (): void {
    echo json_encode([
        'status' => 'ok',
        'service' => 'oa-care-api',
        'time' => gmdate(DATE_ATOM),
    ]);
});

$router->post('/api/v1/patients', [new PatientController(), 'create']);
$router->get('/api/v1/patients/{id}', [new PatientController(), 'show']);
$router->post('/api/v1/assessments', [new AssessmentController(), 'create']);
$router->get('/api/v1/patients/{id}/assessments', [new AssessmentController(), 'listByPatient']);
$router->get('/api/v1/education', [new EducationController(), 'index']);
$router->post('/api/v1/education/ingest', [new EducationController(), 'ingest']);

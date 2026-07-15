<?php

declare(strict_types=1);

require dirname(__DIR__) . '/bootstrap.php';

use OACare\Services\Ai\OsteoarthritisRiskEngine;

$engine = new OsteoarthritisRiskEngine();

$base = [
    'pain_score' => 3,
    'stiffness_minutes' => 15,
    'mobility_score' => 8,
    'sleep_quality' => 8,
    'activity_minutes' => 30,
    'medication_adherence' => 9,
    'swollen_hot_joint' => false,
    'fever' => false,
    'unable_to_bear_weight' => false,
    'recent_trauma' => false,
];

$low = $engine->analyze($base);
assert($low['risk_tier'] === 'low');

$urgent = $engine->analyze(array_merge($base, ['fever' => true]));
assert($urgent['risk_tier'] === 'urgent');
assert($urgent['score'] === 100);

echo "RiskEngineTest passed\n";

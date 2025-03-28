<?php
/**
 * CARD DISTRIBUTION API
 * 
 * Purpose: Validates input and returns JSON response
 * Usage:
 * - cardApp.js sends POST request with numPeople
 * - here validates numPeople input and calls distribute function
 * - returns result or error
 * 
 * Remarks:
 * - require POST request with JSON like: {"numPeople":4}
 * - Some people may get blank result if numPeople > 52
 */

header('Content-Type: application/json');

require_once 'distributionService.php';

try {
    $numPeople = $_GET['numPeople'] ?? null;

    if($numPeople <= 0) {
        throw new Exception("Input value does not exist or value is invalid");
    }
    
    //call distribute function from distributionService.php
    $distributor = new CardDistributor();
    $distribution = $distributor->distribute((int)$numPeople);

    //separate card by coma
    $result = array_map(function($cards) {
        return implode(',', $cards);
    }, $distribution);

    echo json_encode([
        'success' => true,
        'distribution' => $result
    ]);
    
} catch(Exception $e) {
    http_response_code(400);
    echo json_encode([
        'ok' => false,
        'message' => $e->getMessage()
    ]);
}
?>
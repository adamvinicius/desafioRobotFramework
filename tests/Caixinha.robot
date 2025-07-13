*** Settings ***
Documentation   Documentacao da API: https://points-app-backend.vercel.app/docs
Resource        ../resource/Api.resource
Suite Setup    Create Session API

*** Test Cases ***

TC: Deposito de Saldo na Caixinha
    [Documentation]     Deposita, Retorna Extrato e Saldo da Caixinha
    [Tags]      POST
    POST /login    srodrigues@example.net    Senha@123
    Validate Status Code    200    
    POST /caixinha/deposit    amount=50
    Validate Status Code    200
    Validate Dict Item    message    Depósito na caixinha realizado.
    GET /points/saldo
    Validate Status Code    200
    Validate Dict Item    normal_balance    120
   

TC: Resgate de Saldo na Caixinha
    [Documentation]     retira Saldo da Caixinha
    [Tags]      POST
    POST /login    srodrigues@example.net    Senha@123
    Validate Status Code    200    
    POST /caixinha/withdraw    amount=50
    Validate Status Code    200
    Validate Dict Item    message    Resgate da caixinha realizado.
    GET /points/saldo
    Validate Status Code    200

TC: Deposito de Saldo na Caixinha com amount invalido
    [Tags]      POST
    POST /login    srodrigues@example.net    Senha@123
    Validate Status Code    200    
    POST /caixinha/deposit    amount=invalido
    Validate Status Code    400  

TC: Deposito de Saldo na Caixinha com amount nulo
    [Tags]      POST
    POST /login    srodrigues@example.net    Senha@123
    Validate Status Code    200    
    POST /caixinha/deposit    amount=${None}
    Validate Status Code    400

TC: Resgate de Saldo na Caixinha com amount invalido
    [Documentation]     retira Saldo da Caixinha
    [Tags]      POST
    POST /login    srodrigues@example.net    Senha@123
    Validate Status Code    200    
    POST /caixinha/withdraw    amount=invalido
    Validate Status Code    400
    Validate Dict Item    message    Resgate da caixinha realizado.

TC: Resgate de Saldo na Caixinha com amount nulo
    [Documentation]     retira Saldo da Caixinha
    [Tags]      POST
    POST /login    srodrigues@example.net    Senha@123
    Validate Status Code    200    
    POST /caixinha/withdraw    amount=${None}
    Validate Status Code    400
    Validate Dict Item    message    Resgate da caixinha realizado.


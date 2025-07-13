*** Settings ***
Documentation   Documentacao da API: https://points-app-backend.vercel.app/docs
Resource        ../resource/Api.resource
Suite Setup    Create Session API

*** Test Cases ***

TC: Envia pontos, retorna extrato e saldo
    [Documentation]     Envia pontos, retorna extrato e saldo
    [Tags]      POST
    POST /login    joao@example.com    Senha@123
    Validate Status Code    200    
    Armazena o token
    GET /points/saldo
    Validate Status Code    200
    Armazena valor do saldo
    POST /points/send    recipientCpf=27078441010    amount=30
    Validate Status Code    200
    Validate Dict Item    message    Pontos enviados com sucesso.
    GET /points/extrato
    Validate Status Code    200
    GET /points/saldo
    Validate Status Code    200
    Valida valor total do saldo

TC: Envia pontos com cpf inexistente
    [Tags]      POST
    POST /login    joao@example.com    Senha@123
    Validate Status Code    200    
    Armazena o token
    POST /points/send    recipientCpf=1221    amount=30
    Validate Status Code    404
    Validate Dict Item    error  Usuário destino não encontrado  

TC: Envia pontos com valor insulficente
    [Tags]      POST
    POST /login    joao@example.com    Senha@123
    Validate Status Code    200    
    Armazena o token
    POST /points/send    recipientCpf=1221    amount=99404100
    Validate Status Code    400
    Validate Dict Item    error  Saldo insuficiente

TC: Envia pontos com valor negativo
    [Tags]      POST
    POST /login    joao@example.com    Senha@123
    Validate Status Code    200    
    Armazena o token
    POST /points/send    recipientCpf=1221    amount=-1
    Validate Status Code    400
    Validate Dict Item    error  Valor inválido

TC: Envia pontos com valor invalido
    [Tags]      POST
    POST /login    joao@example.com    Senha@123
    Validate Status Code    200    
    Armazena o token
    POST /points/send    recipientCpf=1221    amount=invalido
    Validate Status Code    400
    Validate Dict Item    error  Valor inválido  

TC: Envia pontos com valor nulo
    [Tags]      POST
    POST /login    joao@example.com    Senha@123
    Validate Status Code    200    
    Armazena o token
    POST /points/send    recipientCpf=1221    amount=${None}
    Validate Status Code    400
    Validate Dict Item    error  Valor inválido  
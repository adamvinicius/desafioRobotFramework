*** Settings ***
Documentation   Documentacao da API: https://points-app-backend.vercel.app/docs
Resource        ../resource/Api.resource
Suite Setup    Create Session API

*** Test Cases ***


TC: Cadastra, Valida, e deleta um novo usuário
    [Documentation]     Atualizar CPF Unico(https://www.4devs.com.br/gerador_de_cpf) 
    ...    Na massa cadastro.json
    [Tags]      POST    
    POST /cadastro valido com cpf e email gerado    Joao da Silva    Senha@123    Senha@123
    Validate Status Code    201
    Validate Dict Item    message    Cadastro realizado com sucesso.  
    GET /confirm-email
    Validate Status Code    200
    Validate Content    E-mail confirmado com sucesso.
    POST /login com dados criados
    Validate Status Code    200
    Validate not empyt    token
    DELETE /account
    Validate Status Code    200
    Validate Dict Item    message    Conta marcada como deletada.

TC: Cadastro com cpf invalido
    POST /cadastro    45124    joao@example.com    Joao da Silva    Senha@123    Senha@123
    Validate Status Code    400
    Validate Dict Item    error    CPF inválido

TC: Cadastro com cpf nulo
    POST /cadastro    cpf=${None}    email=joao    fullName=Joao da Silva    password=Senha@123    confirmPassword=Senha@123
    Validate Status Code    400
    Validate Dict Item    error    CPF inválido

TC: Cadastro com email existente
    POST /cadastro    31860521061    joao@example.com    Joao da Silva    Senha@123    Senha@123
    Validate Status Code    400
    Validate Dict Item    error    duplicate key value violates unique constraint \"users_email_key\"

TC: Cadastro com email invalido
    POST /cadastro    31860521061    joao    Joao da Silva    Senha@123    Senha@123
    Validate Status Code    400
    Validate Dict Item    error    Email inválido

TC: Cadastro com email nulo
    POST /cadastro    31860521061    ${None}    Joao da Silva    Senha@123    Senha@123
    Validate Status Code    400
    Validate Dict Item    error    Email inválido

TC: Cadastro com nome nulo
    POST /cadastro    31860521061    joao@example.com    ${None}    Senha@123    Senha@123
    Validate Status Code    400
    Validate Dict Item    error    Nome completo obrigatório

TC: Cadastro com senha sem caracteres especiais
    POST /cadastro    31860521061    joao@example.com    Joao da Silva    Senha123    Senha123
    Validate Status Code    400
    Validate Dict Item    error    Senha fraca

TC: Cadastro com senha divergente
    POST /cadastro    31860521061    joao@example.com    Joao da Silva    Senha@123    Senha@124
    Validate Status Code    400
    Validate Dict Item    error    Senhas não conferem

TC: Cadastro com senha nulo
    POST /cadastro    31860521061    joao@example.com    Joao da Silva    ${None}    ${None}
    Validate Status Code    400
    Validate Dict Item    error    campo senha e obrigaotorio

TC: confirm email com token invalido
    GET /confirm-email com token    token=invalido
    Validate Status Code    400
    Validate Content    Token inválido ou expirado. 

TC: Login com usuario inexistente
    POST /login    teste@asdf.com    Senha@123
    Validate Status Code    400
    Validate Dict Item    error    Credenciais inválidas

TC: Login com senha invalida
    POST /login    joao@example.com    Senha@1234
    Validate Status Code    400
    Validate Dict Item    error    Credenciais inválidas

TC: Delete com password invalido
    DELETE /account com password    teste@471
    Validate Status Code    401
    Validate Dict Item    error    Token inválido ou expirado
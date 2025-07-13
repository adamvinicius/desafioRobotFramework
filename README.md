# REST API Robot Framework

Automação de tests de API em [Robot Framework](https://robotframework.org/#resources) com [RequestsLibrary](https://github.com/MarketSquare/robotframework-requests#readme)

## Pre-requisitos

Para clonar e rodar esse projeto, você precisará:

- [Git](https://git-scm.com/downloads)
- [Python](https://www.python.org/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Robot Framework Language Server Extension](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp)

- `git clone <repository_url>`
- `cd repo`

## Instalação

Instale as dependencias

- `python -m pip install -r requirements.txt`

## Rodando os testes

Nesse Projeto, voce pode rodar testes via CLI, gerar os relatorios com a flag `-d` e com a flag `-v` passar o caminho da suite a ser testada, a suite escolhida: `tests/nome-da-suite-de-teste.robot`:

- para rodar Auth `python -m robot -d reports -v tests/Auth.robot`
- para rodar Points `python -m robot -d reports -v tests/Points.robot`
- para rodar Caixinha `python -m robot -d reports -v tests/Caixinha.robot`
- para rodar todos as suites `python -m robot -d reports -v tests tests/`

### Bugs encontrados

a) Há bugs? Quais são e cenários esperados?
Sim,

    Ao enviar o campo passowrd e confirmPassword nulos
	O mesmo informa que as senhas são fracas ao inves de campos obrigatorios
	
	O deposito esta sendo feito normalmente
	Mas no saldo não está somando
	
	A retirada de pontos não está sendo possível
	Mesmo tendo saldo suficiente
	
	No deposito ao enviar uma String ou nulo no campo amount, o mesmo retorna sucesso
	Oq provavelmente nao está tendo ação de soma
	
	O mesmo acontece com o endpoint de retirada
	
	
___

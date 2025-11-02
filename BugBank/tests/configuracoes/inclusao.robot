*** Settings ***
Library    Browser
Resource   ../../../shared/login.robot
Resource   ../configuracoes/resources/pages/inclusao/cadastrar.robot

*** Test Cases ***
Cadastro De Novo Usuario Com Saldo
    [Documentation]    Testa o cadastro completo, incluindo a opção de saldo inicial.
    Given Que Eu Abro A Pagina Inicial Do BugBank
    When Eu Preencho O Cadastro Com Dados Padrao
    Then Devo Receber Uma Mensagem De Sucesso
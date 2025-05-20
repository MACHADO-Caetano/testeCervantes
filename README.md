# 📘 Teste Cervantes
Projeto utilizando Windows Forms, onde executa uma tela de cadastro, e registra e valida os cadatros em um banco de dados Postgresql, também possuindo registros de logs.

Este projeto vem de encontro a cumprir com o primeiro teste para o processo seletivo da empresa Cervantes, atendendo aos requisitos, e funcionando com as devidas validações. 

# Estrutura do Projeto
O projeto constitui em um formulário, desenvolvido com a tecnologia Windows Forms, onde temos uma tela inicial de cadastro, na temática, de usuários para o formulário. Estes, possuem um código e um nome como atributos. Os dados cadastrados nesse formulário, são validados inicialmente, pelo frontend, de forma auxiliar ao banco de dados, para evitar que o usuário insira alguns caracteres inválidos (como sinais ortográficos, acentos), espaços nulos e dados indevidos (como números em campo de cadeia de caracteres), para que, quando recebidos pelo banco de dados, sejam validados para realizar as operações básicas do CRUD - Create, Read, Update, Delete.

O banco de dados em Postgresql, possui algumas validações para que o mesmo possa cadastrar efetivamente os dados, sendo esse cadastro realizado em duas tabelas:

- Tabela principal de cadastros;
- Tabela de logs;

Fora utilizado triggers, sendo:

- log_cadastros_changed: esta que envia para uma tabela, os registos das funções na tela de cadastros, registrando qual função do CRUD foi realizada, qual cadastro foi alterado;
-  Constraint: Utilizei uma constraint na tabela cadastros, que valida o dado de codUser, para que o mesmo não seja instanciado no banco igual a 0 ou inferior a este.

Na interface, foi trabalhado responsividade, e também um layout mais receptivo ao usuário, também foi pensado nas respostas a cada validação e a cada função, retornando sempre que possível uma mensagem afirmativa ou negativa quanto à usabilidade da tela de cadastros.

📦 Instalação

Programa

Clone o repositório em um diretório seguro:
```
git clone https://github.com/MACHADO-Caetano/testeCervantes.git
```

Depois, você deve possuir o Visual Studio, IDE utilizada para rodar os programas em Windows Forms, se não houver instalado, podes instalá-lo por aqui:
```
https://visualstudio.microsoft.com/pt-br/
```

Banco de Dados

Utilize o pgadmin4, abra um query e execute o schema localizado na pasta "data" desde repositório

⚙️ Uso

Para utilizar o programa, abra o visual studio, realize as connfigurações iniciais, abra o diretório do projeto, e execute-o, com o inicializador/compilador, localizado na região topo-central da IDE

🛠️ Tecnologias Utilizadas

- Windows Forms;
- Postgresql e pgadmin4;
- Visual Studio;
- Git (Bash)




# Storage Management

Projeto desenvolvido no âmbito da unidade curricular Sistemas Operativos

## Funcionalidade

Monitorizar o espaço ocupado em disco, e a sua variação ao longo do tempo,
por ficheiros com determinadas propriedades.

## How to Run

First you need to install docker and docker-compose

```
brew install docker
brew install docker-compose
```

Then you `chmod +x ./executer.sh` and every time you run `./executer` the container will start and you'll be able to access the terminal. The directory will be
/app and the project files will be there.

You don't need to exit the terminal for changes in the code to be reflected in the virtual environment.

## Usage

- [x] **-n** - Seleção dos ficheiros a contabilizar;
- [x] **-d** - Data máxima dos ficheiros a contabilizar;
- [x] **-s** - Tamanho mínimo dos ficheiros a contabilizar;
- [x] **-r** - Inverter a ordem de visualização;
- [x] **-a** - Ordenar por nome;
- [x] **-l** - Limite de linhas da tabela;

## Development resources

- [stat](https://www.geeksforgeeks.org/stat-command-in-linux-with-examples/)
- [awk](https://www.cyberciti.biz/faq/bash-scripting-using-awk/)
- [bc](https://www.geeksforgeeks.org/bc-command-linux-examples/)
- [du](https://www.geeksforgeeks.org/du-command-linux-examples/)
- [getopts](https://www.stackchief.com/tutorials/Bash%20Tutorial%3A%20getopts)

## Iteração 1

### Requisito

Tamanho, nome e data dos diretorios e sub-diretorios inseridos diretamente no script
na interface pretendida.

- [x] Listar diretorios e sub-diretorios
- [x] Informação dos diretorios
- [x] Fazer interface

## Iteração 2

### Requisitos

Leitura dos argumentos e opções

O script [spacecheck](https://github.com/guilherme096/storage_monitor/blob/main/spacecheck.sh)
deve tratar de forma correta ficheiros e diretorias que contenham
espaços no seu nome. Sempre que, por alguma razão (falta de permissões, por exemplo), não seja
possível aceder a uma diretoria ou determinar o tamanho de um ficheiro numa diretoria, o espaço
ocupado pelos ficheiros dessa diretoria deve ser assinalado com NA.

#### Gui

- [x] Verificar cada Flag
- [x] Lidar com cada Flag
  - [x] -n
  - [x] -d
  - [x] -s
  - [x] -r

#### Maria

- [x] Receber diretorio como argumento
- [x] Lidar com diretorios não existentes
- [x] -a flag
- [x] -l flag

## Spacerate

- [x]Verifcar se são colocados 2 argumentos
- [x]Verificar se os ficheiros existem
- Comparar os ficheiros
  - [x] Adicionar oo contudo de cada ficheiro a um array associativo
  - [x] Calcular as difrenças de size (está a fazer mal as contas)
  - [x] Verificar se há novos dirs -> marcar como NEW
  - [x] Verificar se há dirs que foram apagados -> marcar como REMOVED
- [x] Ordernar o output usando -a flag e -r flag
- [x] Interface

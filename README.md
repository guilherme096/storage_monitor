# Storage Management

## Funcionalidade

Monitorizar o espaço ocupado em disco, e a sua variação ao longo do tempo,
por ficheiros com determinadas propriedades.

## Usage

- **-n** - Seleção dos ficheiros a contabilizar;
- **-d** - Data máxima dos ficheiros a contabilizar;
- **-s** - Tamanho mínimo dos ficheiros a contabilizar;
- **-r** - Inverter a ordem de visualização;
- **-a** - Ordenar por nome;
- **-l** - Limite de linhas da tabela;

## Resources

- [awk](https://www.cyberciti.biz/faq/bash-scripting-using-awk/)
- [bc](https://www.geeksforgeeks.org/bc-command-linux-examples/)
- [du](https://www.geeksforgeeks.org/du-command-linux-examples/)
- [getopts](https://www.stackchief.com/tutorials/Bash%20Tutorial%3A%20getopts)

# Plano

❌ Perceber o que é para fazer

## Iteração 1

### Requisito

Tamanho, nome e data dos diretorios e sub-diretorios inseridos diretamente no script
na interface pretendida.

- [ ] Listar diretorios e sub-diretorios
- [ ] Informação dos diretorios
- [ ] Fazer interface

## Iteração 2

### Requisitos

Leitura dos argumentos e opções

O script [spacecheck](https://github.com/guilherme096/storage_monitor/blob/main/spacecheck.sh)
deve tratar de forma correta ficheiros e diretorias que contenham
espaços no seu nome. Sempre que, por alguma razão (falta de permissões, por exemplo), não seja
possível aceder a uma diretoria ou determinar o tamanho de um ficheiro numa diretoria, o espaço
ocupado pelos ficheiros dessa diretoria deve ser assinalado com NA.

- [ ] Leitura do diretorio atual
- [ ] Leitura do diretorio como argumento
- [ ] Opções

## Inicio de escrita do relatório

# Nome do projeto
Descrição detalhada sobre o projeto, como ele irá funcionar e o que ele deverá fazer.

## Entidades
Todas as entidades que irão compor o projeto estarão listadas aqui, divididas por headings com seus respectivos
nomes e com seus atributos especificados por tabelas.

**Observação:** Atributos com asterisco são obrigatórios.

### User (exemplo)
| Nome | Tipo | Notas |
| -- | -- | -- |
| id* | UserId | Deve se comportar como um ObjectId. |
| name* | UserName | Deve ter um limite mínimo de 8 caracteres; Deve ter um limite máximo de 16 caracteres. |
| mailAddress* | MailAddress | Deve ter um formato correto de e-mail. |
| password* | Password | Deve ter um limite mínimo de 10 caracteres; Deve ter limite máximo de 24 caracteres; Deve conter, pelo menos, um número, uma letra e um caracter especial. |
| secondaryMailAddress | MailAddress | Mesma regra do `mailAddress`. |

## Use cases
Todos os use cases que irão compor o projeto estarão listados aqui, divididos por headings com seus respectivos
nomes e com seu fluxo detalhado em passos.

### CreateUser (exemplo)
1. Verificar se já existe um usuário com as credenciais fornecidas (`User.name` e `User.mailAddress`).
    1.1 Caso exista, retornar erro `UserAlreadyExists`.
2. Enviar o `User.password` para o repositório responsável pelo salt de senhas para criar o hash da senha.
3. Converter a entidade `User` em model (database) `User` e enviar para o repositório de `User` para persistir os dados no banco.
4. Retornar sucesso.
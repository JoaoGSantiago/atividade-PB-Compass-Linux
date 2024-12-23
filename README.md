

<h1>Atividade de Linux PB - NOV 2024 | DevSecOps</h1>

<nav>
    <ul>
        <li><a href="#instalação-wsl">0. Instalação da WSL</a></li>
        <li><a href="#criar-instancia">1. Criação da Instância na AWS</a></li>
        <li><a href="#configuracao-instancia">2. Configuração da Instância</a></li>
        <li><a href="#script-monitoração">3. Criando e Configurando o Script de Monitoração</a></li>
        <li><a href="#configuracao-cron">4. Configuração do Cron</a></li>
        <li><a href="#testando-script">5. Testando o Script e Configurações</a></li>
        <li><a href="#versionamento">6. Versionar o Script</a></li>
    </ul>
</nav>

<h2 id="instalação-wsl">0. Instalação da WSL no windows</h2>
    <ol>
        <li>Acesse o <strong>PowerShell</strong> como Administrador.</li>
        <li>Execute o seguinte comando para instalar e configurar a WSL:
            <pre><code>wsl --install</code></pre>
        <li>Aguarde a instalação e reinicie o computador, se solicitado.</li>
        <li>Após isso, instale o Ubuntu na versão 20.04:
                <pre><code>wsl --instal -d Ubunutu-20.04</code></pre>
            </li>
        <li>Certifique-se de que a WSL com o Ubuntu está instalada corretamente verificando a versão:
            <pre><code>wsl --list --verbose</code></pre>
        </li>
    </ol>

<h2 id="criar-instancia">1. Configuração e criação da Instância na AWS</h2>
    <ol>
        <li>Procure o serviço <strong>VPC</strong> e realize os seguintes passos para conseguir o acesso à internet:
            <ul>
                <li>No serviço <strong>Internet Gateway</strong>, clique em <strong>Create Internet Gateway</strong>.</li>
                <li>Associe o <strong>Internet Gateway</strong> em uma <strong>Route Table</strong>.</li>
                <li>Clique em <strong>Add Route</strong> e configure:
                    <ul>
                        <li><strong>Destination:</strong> 0.0.0.0/0 (rota para qualquer destino).</li>
                        <li><strong>Target:</strong> Internet Gateway.</li>
                    </ul>
                </li>
            </ul>
        </li>
        <li>Agora, criar a instância na AWS para poder colocar o serviço <strong>Nginx</strong> e o script de monitoramento:
            <ul>
                <li>Acesse o serviço <strong>EC2</strong> e clique em <strong>Launch instances</strong>.</li>
                <li>Configure:
                    <ul>
                        <li>Escolha a <strong>AMI</strong> (Amazon Machine Image).</li>
                        <li>Selecione o <strong>Instance Type</strong>.</li>
                        <li>Selecione o tipo de instânci, como a t2.micro.</li>
                        <li>Crie uma <strong>Key Pair</strong> e associe a Instância, para deixa-la mais segura.</li>
                        <li>Configure a <strong>Network</strong>, permitindo <strong>SSH (porta 22)</strong> e <strong>HTTP (porta 80)</strong>.</li>
                    </ul>
                </li>
            </ul>
        </li>
        <li>Finalize clicando em <strong>Launch Instance</strong> para, finalmente, poder criar a Instância.</li>
    </ol>
<h2 id="configuracao-instancia">2. Configuração da Instância</h2>
<ol>
    <li>Agora, para fazer o download do <strong>Key Pair</strong> associado à instância.</li>
    <li>Altere a permissão da chave para que seja somente leitura para o usuário root:
        <pre><code>chmod 400 KeyProjeto.pem</code></pre>
    </li>
    <li>Conecte à instância via SSH:
        <pre><code>ssh -i KeyProjeto.pem ec2-user@&lt;IP-da-instância&gt;</code></pre>
    </li>
    <li>Instale o serviço <strong>Nginx</strong>:
        <pre><code>sudo yum install nginx</code></pre>
    </li>
    <li>Ative e verifique o serviço Nginx:
        <pre><code>sudo systemctl start nginx</code></pre>
        <pre><code>sudo systemctl enable nginx</code></pre>
    </li>
</ol>

<h2 id="script-monitoração">3. Criando e Configurando o Script de Monitoração</h2>
<ol>
    <li>Crie um script para monitorar o estado do Nginx, verificando se o serviço está <strong>online</strong> ou <strong>offline</strong>.</li>
    <li>Utilize o comando <strong>date</strong> para capturar o timestamp nos logs, tendo em vista que os caracteres abaixo mostram os detalhes dos respectivos tempo:
        <ul>
            <li>%Y: ano</li>
            <li>%m: mês</li>
            <li>%d: dia</li>
            <li>%H: hora</li>
            <li>%M: minuto</li>
            <li>%S: segundos</li>
        </ul>
    </li>
    <li>Agora, crie as variáveis <strong>status_online</strong> e <strong>status_offline</strong> para poder registrar o status do serviço em logs distintos.</li>
    <li>No script, em uma estrutura de condição(if) use o comando <strong>systemctl</strong> para verificar o status do serviço e aplique os comandos:
        <ul>
            <li><strong>is-active</strong>: retorna se o serviço está ativo.</li>
            <li><strong>--quiet</strong>: fornece apenas o código de saída.</li>
        </ul>
    </li>
    <li>Com a estrutura de condição e os comandos utilizados acima, o serviço do Nginx sairá como resultado:
        <ul>
            <li>Online: <strong>monitoracao_online.log</strong>.</li>
            <li>Offline: <strong>monitoracao_offline.log</strong>.</li>
        </ul>
    </li>
    <li>Agora, salve o script e torne executável:
        <pre><code>chmod +x script_status_nginx.sh</code></pre>
    </li>
</ol>

<h2 id="configuracao-cron">4. Configuração do Cron</h2>
<ol>
    <li>o Comando <strong>Cron</strong> permite agendar a execução automática de tarefas no Linux.</li>
    <li>Edite o arquivo <strong>crontab</strong> usando:
        <pre><code>crontab -e</code></pre>
    </li>
    <li>Adicione o seguinte código para executar o script a cada 5 minutos:
        <pre><code>*/5 * * * * bash ~/script_status_nginx.sh</code></pre>
    <li>Sendo que o <code>* * * * *</code> é o minuto, hora, dia do mês, mês e dia da semana, respectivamente</li>
    <li>quando coloca <code>*/5</code> quer dizer que vai ser executado a cada 5 unidades(minutos)</li>
    </li>
    <li>Salve e feche o arquivo.</li>
    <li>Ative o serviço Cron para poder iniciar o monitoramento:
        <pre><code>sudo systemctl start crond</code></pre>
    </li>
</ol>

<h2 id="testando-script">5. Testando o Script e Configurações</h2>
<ol>
    <li>Aguarde 5 minutos para o <strong>Cron</strong> executar o script.</li>
    <li>Agora, verifique o log de monitoramento online:
        <pre><code>cat monitoracao_online.log</code></pre>
        <ul>
            <li>Exemplo de saída do log:
                <div align="center">
                <img src="https://github.com/user-attachments/assets/11511f61-8756-4eab-b1f1-52bc2e9fb91d" width="700px" />
                </div>
            </li>
        </ul>
    </li>
    <li>Por fim, testar o monitoramento offline:
        <ul>
            <li>Pare o serviço Nginx:
                <pre><code>sudo systemctl stop nginx</code></pre>
            </li>
            <li>Após 5 minutos, verifique o log de monitoramento offline:
                <pre><code>cat monitoracao_offline.log</code></pre>
            </li>
            <li>Exemplo de saída do log:
                <div align="center">
                <img src="https://github.com/user-attachments/assets/05b842f8-193d-4eae-b8be-8c46e5f4caec" width="700px" />
                </div>
            </li>
        </ul>
    </li>
</ol>
<h2 id="versionamento">6. Versionando o Script</h2>
<ol>
    <li>Para fazer o versionamento do Script de monitoramento usa-se o <strong>Git</strong>.</li>
    <li>Para versionar precisa fazer o passo a passo:
        <pre><code>git init</code></pre>
        <pre><code>git add script_status_nginx</code></pre>
        <pre><code>git commit -m "commit do Script de monitoramento"</code></pre>
    </li>
    <li>Agora, hospedar o repositório remotamente com o <strong>GitHub</strong>:
        <ul>
            <li>Criar repositório no GitHub</li>
            <li>Adicionar o repositório na máquina com:</li>
            <pre><code>git remote add origin "https://github.com/JoaoGSantiago/atividade-PB-Compass-Linux.git"</code></pre>
            <li>Enviar os arquivos para o repositório remoto</li>
            <pre><code>git push -u origin main"</code></pre>
        </ul>
</ol>

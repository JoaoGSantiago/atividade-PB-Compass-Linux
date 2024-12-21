

<h1>Atividade de Linux PB - NOV 2024 | DevSecOps</h1>

<nav>
    <ul>
        <li><a href="#criar-instancia">1. Criação da Instância na AWS</a></li>
        <li><a href="#configuracao-instancia">2. Configuração da Instância</a></li>
        <li><a href="#script-monitoração">3. Criando e Configurando o Script de Monitoração</a></li>
        <li><a href="#configuracao-cron">4. Configuração do Cron</a></li>
        <li><a href="#testando-script">5. Testando o Script e Configurações</a></li>
        <li><a href="#versionamento">6. Versionar o Script</a></li>
    </ul>
</nav>

<h2 id="criar-instancia">1. Configuração e criação da Instância na AWS</h2>

<ol>
    <li>Procurar o serviço <strong>VPC</strong> e, realizer os seguintes passos:.</li>
        <ul>
            <li>No serviço <strong>Internet Gateway</strong> apertar <strong>Create Internet Gateway</strong></li>
            <li>Após isso, associar a <strong>Internet Gateway</strong> em uma <strong>Route Table</strong></li>
            <li>Clicar em <strong>Add Route</strong> e colocar o <strong>Destination</strong> em 0.0.0.0/0(rota para qualquer destino) e o <strong>Target</strong> em <strong>Internet Gateway</strong></li>
        </ul>
    <li>No dashboard do serviço <strong>EC2</strong>, clicar em <strong>"Launch instances"</strong> e configurar:.
        <ul>
            <li>Escolher a <strong>AMI</strong> (Amazon Machine Image).</li>
            <li>Selecionar o <strong>Instance type</strong>.</li>
            <li>Configurar o <strong>Key Pair</strong>.</li>
            <li>Configurar a <strong>Network</strong>, permitir o <strong>SSH (porta 22)</strong> e <strong>HTTP (porta 80)</strong>.</li>
        </ul>
    </li>
    <li>Finalizar clicando em <strong>"Launch Instance"</strong>.</li>
</ol>

<h2 id="configuracao-instancia">2. Configuração da Instância</h2>
<ol>
    <li>Fazer o download do <strong>Key Pair</strong> associado à instância.</li>
    <li>Alterar a permissão da chave para que seja somente leitura para o usuário root:
        <pre><code>chmod 400 KeyProjeto.pem</code></pre>
    </li>
    <li>Conectar à instância via SSH:
        <pre><code>ssh -i KeyProjeto.pem ec2-user@&lt;IP-da-instância&gt;</code></pre>
    </li>
    <li>Instalar o serviço <strong>Nginx</strong>:
        <pre><code>sudo yum install nginx</code></pre>
    </li>
    <li>Ativar e verificar o serviço Nginx:
        <pre><code>sudo systemctl start nginx</code></pre>
        <pre><code>sudo systemctl enable nginx</code></pre>
    </li>
</ol>

<h2 id="script-monitoração">3. Criando e Configurando o Script de Monitoração</h2>
<ol>
    <li>Criar um script para monitorar o estado do Nginx, verificando se está <strong>online</strong> ou <strong>offline</strong>.</li>
    <li>Utilizar o comando <strong>date</strong> para capturar o timestamp nos logs:
        <ul>
            <li>%Y: ano</li>
            <li>%m: mês</li>
            <li>%d: dia</li>
            <li>%H: hora</li>
            <li>%M: minuto</li>
            <li>%S: segundos</li>
        </ul>
    </li>
    <li>Configurar as variáveis <strong>status_online</strong> e <strong>status_offline</strong> para registrar em logs distintos.</li>
    <li>No script, usar o comando <strong>systemctl</strong> para verificar o status do serviço:
        <ul>
            <li><strong>is-active</strong>: retorna se o serviço está ativo.</li>
            <li><strong>--quiet</strong>: fornece apenas o código de saída.</li>
        </ul>
    </li>
    <li>Fazer o script registrar os logs:
        <ul>
            <li>Online: <strong>monitoracao_online.log</strong>.</li>
            <li>Offline: <strong>monitoracao_offline.log</strong>.</li>
        </ul>
    </li>
    <li>Tornar o script executável:
        <pre><code>chmod +x script_status_nginx.sh</code></pre>
    </li>
</ol>

<h2 id="configuracao-cron">4. Configuração do Cron</h2>
<ol>
    <li><strong>Cron</strong> permite agendar a execução automática de tarefas no Linux.</li>
    <li>Editar o arquivo <strong>crontab</strong>:
        <pre><code>crontab -e</code></pre>
    </li>
    <li>Adicionar o seguinte código para executar o script a cada 5 minutos:
        <pre><code>*/5 * * * * bash ~/script_status_nginx.sh</code></pre>
    </li>
    <li>Salvar e fechar o arquivo.</li>
    <li>Ativar o serviço Cron:
        <pre><code>sudo systemctl start cron</code></pre>
    </li>
</ol>

<h2 id="testando-script">5. Testando o Script e Configurações</h2>
<ol>
    <li>Aguardar 5 minutos para o <strong>Cron</strong> executar o script.</li>
    <li>Verificar o log de monitoramento online:
        <pre><code>cat monitoracao_online.log</code></pre>
        <ul>
            <li>Exemplo de saída:
                <div align="center">
                <img src="https://github.com/user-attachments/assets/11511f61-8756-4eab-b1f1-52bc2e9fb91d" width="700px" />
                </div>
            </li>
        </ul>
    </li>
    <li>Para testar o monitoramento offline:
        <ul>
            <li>Parar o serviço Nginx:
                <pre><code>sudo systemctl stop nginx</code></pre>
            </li>
            <li>Após 5 minutos, verificar o log de monitoramento offline:
                <pre><code>cat monitoracao_offline.log</code></pre>
            </li>
            <li>Exemplo de saída:
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

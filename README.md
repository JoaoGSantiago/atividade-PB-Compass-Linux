
<h1>Atividade de Linux PB - NOV 2024 | DevSecOps</h1>

<nav>
    <ul>
        <li><a href="#criar-instancia">1. Criação da Instância na AWS</a></li>
        <li><a href="#configuracao-instancia">2. Configuração da Instância</a></li>
        <li><a href="#script-monitoração">3. Criando e Configurando o Script de Monitoração</a></li>
        <li><a href="#configuracao-cron">4. Configuração do Cron</a></li>
        <li><a href="#testando-script">5. Testando o Script e Configurações</a></li>
    </ul>
</nav>

<h2 id="criar-instancia">1. Criação da Instância na AWS</h2>
<ol>
    <li>No dashboard do serviço <strong>EC2</strong>, clique em <strong>"Launch instances"</strong>.</li>
    <li>Configure:
        <ul>
            <li>Escolha a <strong>AMI</strong> (Amazon Machine Image).</li>
            <li>Selecione o <strong>Instance type</strong>.</li>
            <li>Configure o <strong>Key Pair</strong>.</li>
            <li>Configure a <strong>Network</strong>, permitindo o <strong>SSH (porta 22)</strong> e <strong>HTTP (porta 80)</strong>.</li>
        </ul>
    </li>
    <li>Finalize clicando em <strong>"Launch Instance"</strong>.</li>
</ol>

<h2 id="configuracao-instancia">2. Configuração da Instância</h2>
<ol>
    <li>Faça o download do <strong>Key Pair</strong> associado à instância.</li>
    <li>Altere a permissão da chave para que seja somente leitura para o usuário root:
        <pre><code>chmod 400 KeyProjeto.pem</code></pre>
    </li>
    <li>Conecte-se à instância via SSH:
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
    <li>Crie um script para monitorar o estado do Nginx, verificando se está <strong>online</strong> ou <strong>offline</strong>.</li>
    <li>Utilize o comando <strong>date</strong> para capturar o timestamp nos logs:
        <ul>
            <li>%Y: ano</li>
            <li>%m: mês</li>
            <li>%d: dia</li>
            <li>%H: hora</li>
            <li>%M: minuto</li>
            <li>%S: segundos</li>
        </ul>
    </li>
    <li>Configure as variáveis <strong>status_online</strong> e <strong>status_offline</strong> para registrar em logs distintos.</li>
    <li>No script, use o comando <strong>systemctl</strong> para verificar o status do serviço:
        <ul>
            <li><strong>is-active</strong>: retorna se o serviço está ativo.</li>
            <li><strong>--quiet</strong>: fornece apenas o código de saída.</li>
        </ul>
    </li>
    <li>Faça o script registrar os logs:
        <ul>
            <li>Online: <strong>monitoracao_online.log</strong>.</li>
            <li>Offline: <strong>monitoracao_offline.log</strong>.</li>
        </ul>
    </li>
    <li>Torne o script executável:
        <pre><code>chmod +x script_status_nginx.sh</code></pre>
    </li>
</ol>

<h2 id="configuracao-cron">4. Configuração do Cron</h2>
<ol>
    <li><strong>Cron</strong> permite agendar a execução automática de tarefas no Linux.</li>
    <li>Edite o arquivo <strong>crontab</strong>:
        <pre><code>crontab -e</code></pre>
    </li>
    <li>Adicione o seguinte código para executar o script a cada 5 minutos:
        <pre><code>*/5 * * * * bash ~/script_status_nginx.sh</code></pre>
    </li>
    <li>Salve e feche o arquivo.</li>
    <li>Ative o serviço Cron:
        <pre><code>sudo systemctl start cron</code></pre>
    </li>
</ol>

<h2 id="testando-script">5. Testando o Script e Configurações</h2>
<ol>
    <li>Aguarde 5 minutos para o <strong>Cron</strong> executar o script.</li>
    <li>Verifique o log de monitoramento online:
        <pre><code>cat monitoracao_online.log</code></pre>
        <p>Exemplo de saída:</p>
        <pre><code>2024-12-19 15:30:00 Serviço Nginx está ONLINE</code></pre>
    </li>
    <li>Para testar o monitoramento offline:
        <ul>
            <li>Pare o serviço Nginx:
                <pre><code>sudo systemctl stop nginx</code></pre>
            </li>
            <li>Após 5 minutos, verifique o log de monitoramento offline:
                <pre><code>cat monitoracao_offline.log</code></pre>
            </li>
        </ul>
        <p>Exemplo de saída:</p>
        <pre><code>2024-12-19 15:35:00 Serviço Nginx está OFFLINE</code></pre>
    </li>
</ol>

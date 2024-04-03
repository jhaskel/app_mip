import 'package:flutter/material.dart';

class PrivacidadePage extends StatelessWidget {
  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => PrivacidadePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Política de Privacidade"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView(
        children: const [
          Text(
            "POLÍTICA DE PRIVACIDADE",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          capitulo("1. Informações gerais"),
          paragrafo(
              "A presente Política de Privacidade contém informações a respeito do modo como tratamos, total ou parcialmente, de forma automatizada ou não, os dados pessoais dos usuários que acessam nosso aplicativo.Seu objetivo é esclarecer os interessados acerca dos tipos de dados que são coletados, dos motivos da coleta e da forma como o usuário poderá atualizar, gerenciar ou excluir estas informações.\nEsta Política de Privacidade foi elaborada em conformidade com a Lei Federal n. 12.965 de 23 de abril de 2014 (Marco Civil da Internet), com a Lei Federal n. 13.709, de 14 de agosto de 2018 (Lei de Proteção de Dados Pessoais) e com o Regulamento UE n. 2016/679 de 27 de abril de 2016 (Regulamento Geral Europeu de Proteção de Dados Pessoais - RGDP).\nEsta Política de Privacidade poderá ser atualizada em decorrência de eventual atualização normativa, razão pela qual se convida o usuário a consultar periodicamente esta seção."),
          capitulo("2. Direitos do usuário"),
          paragrafo(
              'O aplicativo se compromete a cumprir as normas previstas no RGPD, em respeito aos seguintes princípios:\nOs dados pessoais do usuário serão processados de forma lícita, leal e transparente (licitude, lealdade e transparência);\n- Os dados pessoais do usuário serão coletados apenas para finalidades determinadas, explícitas e legítimas, não podendo ser tratados posteriormente de uma forma incompatível com essas finalidades (limitação das finalidades);\n - Os dados pessoais do usuário serão coletados de forma adequada, pertinente e limitada às necessidades do objetivo para os quais eles são processados (minimização dos dados);\n- Os dados pessoais do usuário serão exatos e atualizados sempre que necessário, de maneira que os dados inexatos sejam apagados ou retificados quando possível (exatidão);\n- Os dados pessoais do usuário serão conservados de uma forma que permita a identificação dos titulares dos dados apenas durante o período necessário para as finalidades para as quais são tratados (limitação da conservação);\n- Os dados pessoais do usuário serão tratados de forma segura, protegidos do tratamento não autorizado ou ilícito e contra a sua perda, destruição ou danificação acidental, adotando as medidas técnicas ou organizativas adequadas (integridade e confidencialidade).\nO usuário do aplicativo possui os seguintes direitos, conferidos pela Lei de Proteção de Dados Pessoais e pelo RGPD:\n- Direito de confirmação e acesso: é o direito do usuário de obter do aplicativo a confirmação de que os dados pessoais que lhe digam respeito são ou não objeto de tratamento e, se for esse o caso, o direito de acessar os seus dados pessoais;\n- Direito de retificação: é o direito do usuário de obter do aplicativo, sem demora injustificada, a retificação dos dados pessoais inexatos que lhe digam respeito;\n- Direito à eliminação dos dados (direito ao esquecimento): é o direito do usuário de ter seus dados apagados do aplicativo;\n- Direito à limitação do tratamento dos dados: é o direito do usuário de limitar o tratamento de seus dados pessoais, podendo obtê-la quando contesta a exatidão dos dados, quando o tratamento for ilícito, quando o aplicativo não precisar mais dos dados para as finalidades propostas e quando tiver se oposto ao tratamento dos dados e em caso de tratamento de dados desnecessários;\n- Direito de oposição: é o direito do usuário de, a qualquer momento, se opor por motivos relacionados com a sua situação particular, ao tratamento dos dados pessoais que lhe digam respeito, podendo se opor ainda ao uso de seus dados pessoais para definição de perfil de marketing (profiling);\n- Direito de portabilidade dos dados: é o direito do usuário de receber os dados pessoais que lhe digam respeito e que tenha fornecido ao aplicativo, num formato estruturado, de uso corrente e de leitura automática, e o direito de transmitir esses dados a outro aplicativo;\n- Direito de não ser submetido a decisões automatizadas: é o direito do usuário de não ficar sujeito a nenhuma decisão tomada exclusivamente com base no tratamento automatizado, incluindo a definição de perfis (profiling), que produza efeitos na sua esfera jurídica ou que o afete significativamente de forma similar.\n usuário poderá exercer os seus direitos por meio de comunicação escrita enviada ao aplicativo com o assunto "RGDP-", especificando:\n- Nome completo ou razão social, número do CPF (Cadastro de Pessoas Físicas, da Receita Federal do Brasil) ou CNPJ (Cadastro Nacional de Pessoa Jurídica, da Receita Federal do Brasil) e endereço de e-mail do usuário e, se for o caso, do seu representante;\n- Direito que deseja exercer junto ao aplicativo;\n- Data do pedido e assinatura do usuário;- Todo documento que possa demonstrar ou justificar o exercício de seu direito. O pedido deverá ser enviado ao e-mail: 2bitsw@gmail.com, ou por correio, ao seguinte endereço:\n2Bits Sistemas Web Rua Dom Pedro,40 sala 102;\nBairro Centro;\nBraço do Trombudo - SC;\n89178-000.\n O usuário será informado em caso de retificação ou eliminação dos seus dados.'),
          capitulo("3. Dever de não fornecer dados de terceiros"),
          paragrafo(
              "Durante a utilização do site, a fim de resguardar e de proteger os direitos de terceiros, o usuário do aplicativo deverá fornecer somente seus dados pessoais, e não os de terceiros."),
          capitulo("4. Dados"),
          capitulo("4.1. Tipos de dados coletados"),
          capitulo(
              "4.1.1. Dados de identificação do usuário para realização de cadastro"),
          paragrafo(
              "A utilização, pelo usuário, de determinadas funcionalidades do aplicativo dependerá de cadastro, sendo que, nestes casos, os seguintes dados do usuário serão coletados e armazenados:\n- nome;\n- endereço de e-mail;\n- número de telefone(opcional);"),
          capitulo("4.1.2. Dados informados no formulário de contato"),
          paragrafo(
              "Os dados eventualmente informados pelo usuário que utilizar o formulário de contato disponibilizado no aplicativo, incluindo o teor da mensagem enviada, serão coletados e armazenados."),
          capitulo("4.1.3. Registros de acesso"),
          paragrafo(
              "Em atendimento às disposições do art. 15, caput e parágrafos, da Lei Federal n. 12.965/2014 (Marco Civil da Internet), os registros de acesso do usuário serão coletados e armazenados por, pelo menos, seis meses."),
          capitulo("4.1.4. Dados sensíveis"),
          paragrafo(
              "Não serão coletados dados sensíveis dos usuários, assim entendidos aqueles definidos nos arts. 9º e 10 do RGPD e nos arts. 11 e seguintes da Lei de Proteção de Dados Pessoais. Assim, dentre outros, não haverá coleta dos seguintes dados:\n- dados que revelem a origem racial ou étnica, as opiniões políticas, as convicções religiosas ou filosóficas, ou a filiação sindical do usuário;\n- dados genéticos;\n- dados biométricos para identificar uma pessoa de forma inequívoca;\n- dados relativos à saúde do usuário;- dados relativos à vida sexual ou à orientação sexual do usuário;\n- dados relacionados a condenações penais ou a infrações ou com medidas de segurança conexas."),
          capitulo(
              "4.2. Fundamento jurídico para o tratamento dos dados pessoais"),
          paragrafo(
              "NAo utilizar os serviços do aplicativo, o usuário está consentindo com a presente Política de Privacidade.\nO usuário tem o direito de retirar seu consentimento a qualquer momento, não comprometendo a licitude do tratamento de seus dados pessoais antes da retirada. A retirada do consentimento poderá ser feita pelo e-mail: 2bitsw@gmail.com, ou por correio enviado ao seguinte endereço:\nRua Dom Pedro,40 sala 102;\nBairro Centro;\nBraço do Trombudo - SC;\n89178-000.\n O consentimento dos relativamente ou absolutamente incapazes, especialmente de crianças menores de 16 (dezesseis) anos, apenas poderá ser feito, respectivamente, se devidamente assistidos ou representados.\n O tratamento de dados pessoais sem o consentimento do usuário apenas será realizado em razão de interesse legítimo ou para as hipóteses previstas em lei, ou seja, dentre outras, as seguintes:\n- para o cumprimento de obrigação legal ou regulatória pelo controlador;\n- para a realização de estudos por órgão de pesquisa, garantida, sempre que possível, a anonimização dos dados pessoais;\n- quando necessário para a execução de contrato ou de procedimentos preliminares relacionados a contrato do qual seja parte o usuário, a pedido do titular dos dados;\n- para o exercício regular de direitos em processo judicial, administrativo ou arbitral, esse último nos termos da Lei nº 9.307, de 23 de setembro de 1996 (Lei de Arbitragem);\n- para a proteção da vida ou da incolumidade física do titular dos dados ou de terceiro;\n- para a tutela da saúde, em procedimento realizado por profissionais da área da saúde ou por entidades sanitárias;\n- quando necessário para atender aos interesses legítimos do controlador ou de terceiro, exceto no caso de prevalecerem direitos e liberdades fundamentais do titular dos dados que exijam a proteção dos dados pessoais;\n- para a proteção do crédito, inclusive quanto ao disposto na legislação pertinente."),
          capitulo("4.3. Finalidades do tratamento dos dados pessoais"),
          paragrafo(
              "Os dados pessoais do usuário coletados pelo aplicativo têm por finalidade facilitar, agilizar e cumprir os compromissos estabelecidos com o usuário e a fazer cumprir as solicitações realizadas por meio do preenchimento de formulários.\n Os dados pessoais poderão ser utilizados também com uma finalidade comercial, para personalizar o conteúdo oferecido ao usuário, bem como para dar subsídio ao aplicativo para a melhora da qualidade e funcionamento de seus serviços.\n Os dados de cadastro serão utilizados para permitir o acesso do usuário a determinados conteúdos do aplicativo, exclusivos para usuários cadastrados.\n O tratamento de dados pessoais para finalidades não previstas nesta Política de Privacidade somente ocorrerá mediante comunicação prévia ao usuário, sendo que, em qualquer caso, os direitos e obrigações aqui previstos permanecerão aplicáveis."),
          capitulo("4.4. Prazo de conservação dos dados pessoais"),
          paragrafo(
              "Os dados pessoais do usuário serão conservados por um período não superior ao exigido para cumprir os objetivos em razão dos quais eles são processados.\nO período de conservação dos dados são definidos de acordo com os seguintes critérios:\nOs dados serão armazenados pelo tempo necessário para a prestação de serviços fornecidos pelo site, de acordo com o status do pedido da pessoa.\nOs dados pessoais dos usuários apenas poderão ser conservados após o término de seu tratamento nas seguintes hipóteses:\n- para o cumprimento de obrigação legal ou regulatória pelo controlador;\n- para estudo por órgão de pesquisa, garantida, sempre que possível, a anonimização dos dados pessoais;\n- para a transferência a terceiro, desde que respeitados os requisitos de tratamento de dados dispostos na legislação;\n    - para uso exclusivo do controlador, vedado seu acesso por terceiro, e desde que anonimizados os dados."),
          capitulo("4.5. Destinatários e transferência dos dados pessoais"),
          paragrafo(
              "Os dados pessoais do usuário não serão compartilhadas com terceiros. Serão, portanto, tratados apenas por este aplicativo."),
          capitulo("5. Do tratamento dos dados pessoais"),
          capitulo(
              "5.1. Do responsável pelo tratamento dos dados (data controller)"),
          paragrafo(
              "O controlador, responsável pelo tratamento dos dados pessoais do usuário, é a pessoa física ou jurídica, a autoridade pública, a agência ou outro organismo que, individualmente ou em conjunto com outras, determina as finalidades e os meios de tratamento de dados pessoais.\nNeste aplicativo, o responsável pelo tratamento dos dados pessoais coletados é 2Bits Sistemas Web, representada por João Haskel, que poderá ser contactado pelo e-mail: johaskel@gmail.com ou no endereço:\nRua Dom Pedro, 40, sala 102;\nBairro Centro;\nBraço do Trombudo - SC;\n89178-000.\nO responsável pelo tratamento dos dados se encarregará diretamente do tratamento dos dados pessoais do usuário."),
          capitulo(
              "5.2. Do encarregado de proteção de dados (data protection officer))"),
          paragrafo(
              "O encarregado de proteção de dados (data protection officer) é o profissional encarregado de informar, aconselhar e controlar o responsável pelo tratamento dos dados, bem como os trabalhadores que tratem os dados, a respeito das obrigações do aplicativo nos termos do RGDP, da Lei de Proteção de Dados Pessoais e de outras disposições de proteção de dados presentes na legislação nacional e internacional, em cooperação com a autoridade de controle competente.\nNeste aplicativo o encarregado de proteção de dados (data protection officer) é João Haskel, que poderá ser contactado pelo e-mail: johakel@gmail.com."),
          capitulo("6. Segurança no tratamento dos dados pessoais do usuário"),
          paragrafo(
              "O aplicativo se compromete a aplicar as medidas técnicas e organizativas aptas a proteger os dados pessoais de acessos não autorizados e de situações de destruição, perda, alteração, comunicação ou difusão de tais dados.\nPara a garantia da segurança, serão adotadas soluções que levem em consideração:\nas técnicas adequadas;\n os custos de aplicação;\n a natureza, o âmbito, o contexto e as finalidades do tratamento;\n e os riscos para os direitos e liberdades do usuário.\nO aplicativo utiliza certificado SSL (Secure Socket Layer) que garante que os dados pessoais se transmitam de forma segura e confidencial, de maneira que a transmissão dos dados entre o servidor e o usuário, e em retroalimentação, ocorra de maneira totalmente cifrada ou encriptada.\nNo entanto, o aplicativo se exime de responsabilidade por culpa exclusiva de terceiro, como em caso de ataque de hackers ou crackers, ou culpa exclusiva do usuário, como no caso em que ele mesmo transfere seus dados a terceiro.\nO aplicativo se compromete, ainda, a comunicar o usuário em prazo adequado caso ocorra algum tipo de violação da segurança de seus dados pessoais que possa lhe causar um alto risco para seus direitos e liberdades pessoais.\nA violação de dados pessoais é uma violação de segurança que provoque, de modo acidental ou ilícito, a destruição, a perda, a alteração, a divulgação ou o acesso não autorizados a dados pessoais transmitidos, conservados ou sujeitos a qualquer outro tipo de tratamento.\nPor fim, o aplicativo se compromete a tratar os dados pessoais do usuário com confidencialidade, dentro dos limites legais."),
          capitulo("7. Dados de navegação (cookies)"),
          paragrafo(
              "Cookies são pequenos arquivos de texto enviados pelo aplicativo ao computador do usuário e que nele ficam armazenados, com informações relacionadas à navegação do aplicativo.\nPor meio dos cookies, pequenas quantidades de informação são armazenadas pelo navegador do usuário para que nosso servidor possa lê-las posteriormente. Podem ser armazenados, por exemplo, dados sobre o dispositivo utilizado pelo usuário, bem como seu local e horário de acesso ao aplicativo.\nOs cookies não permitem que qualquer arquivo ou informação sejam extraídos do disco rígido do usuário, não sendo possível, ainda, que, por meio deles, se tenha acesso a informações pessoais que não tenham partido do usuário ou da forma como utiliza os recursos do aplicativo.\nÉ importante ressaltar que nem todo cookie contém informações que permitem a identificação do usuário, sendo que determinados tipos de cookies podem ser empregados simplesmente para que o aplicativo sejam carregado corretamente ou para que suas funcionalidades funcionem do modo esperado.\nAs informações eventualmente armazenadas em cookies que permitam identificar um usuário são consideradas dados pessoais. Dessa forma, todas as regras previstas nesta Política de Privacidade também lhes são aplicáveis.\n"),
          capitulo("7.1. Cookies do aplicativo"),
          paragrafo(
              "Os cookies do aplicativo são aqueles enviados ao computador ou dispositivo do usuário e administrador exclusivamente pelo aplicativo.\nAs informações coletadas por meio destes cookies são utilizadas para melhorar e personalizar a experiência do usuário, sendo que alguns cookies podem, por exemplo, ser utilizados para lembrar as preferências e escolhas do usuário, bem como para o oferecimento de conteúdo personalizado.\nEstes dados de navegação poderão, ainda, ser compartilhados com eventuais parceiros do aplicativo, buscando o aprimoramento dos produtos e serviços ofertados ao usuário."),
          capitulo("7.2. Cookies de redes sociais"),
          paragrafo(
              "O aplicativo utiliza plugins de redes sociais, que permitem acessá-las a partir do aplicativo. Assim, ao fazê-lo, os cookies utilizados por elas poderão ser armazenados no navegador do usuário.\nCada rede social possui sua própria política de privacidade e de proteção de dados pessoais, sendo as pessoas físicas ou jurídicas que as mantêm responsáveis pelos dados coletados e pelas práticas de privacidade adotadas.\nO usuário pode pesquisar, junto às redes sociais, informações sobre como seus dados pessoais são tratados. A título informativo, disponibilizamos os seguintes links, a partir dos quais poderão ser consultadas as políticas de privacidade e de cookies adotadas por algumas das principais redes sociais:\nFacebook: https://www.facebook.com/policies/cookies/\nTwitter: https://twitter.com/pt/privacy\nInstagram: https://help.instagram.com/1896641480634370?ref=ig\nYoutube: https://policies.google.com/privacy?hl=pt-BR&amp;\ngl=pt\nGoogle+: https://policies.google.com/technologies/cookies?hl=pt\nPinterest: https://policy.pinterest.com/pt-br/privacy-policy\nLinkedIn: https://www.linkedin.com/legal/cookie-policy?trk=hp-cookies"),
          capitulo("7.3. Gestão dos cookies e configurações do navegador"),
          paragrafo(
              "O usuário poderá se opor ao registro de cookies pelo aplicativo, bastando que desative esta opção no seu próprio navegador ou aparelho.\nA desativação dos cookies, no entanto, pode afetar a disponibilidade de algumas ferramentas e funcionalidades do aplicativo, comprometendo seu correto e esperado funcionamento. Outra consequência possível é remoção das preferências do usuário que eventualmente tiverem sido salvas, prejudicando sua experiência.\nA seguir, são disponibilizados alguns links para as páginas de ajuda e suporte dos navegadores mais utilizados, que poderão ser acessadas pelo usuário interessado em obter mais informações sobre a gestão de cookies em seu navegador:\nInternet Explorer:https://support.microsoft.com/pt-br/help/17442/windows-internet-explorer-delete-manage-cookies\nSafari:https://support.apple.com/pt-br/guide/safari/sfri11471/mac\nGoogle Chrome:https://support.google.com/chrome/answer/95647?hl=pt-BR&amp;\nhlrm=pt\nMozila Firefox:https://support.mozilla.org/pt-BR/kb/ative-e-desative-os-cookies-que-os-sites-usam\nOpera: https://www.opera.com/help/tutorials/security/privacy/"),
          capitulo("8. Reclamação "),
          paragrafo(
              "Diretamente no aplicativo através de formulários padronizados"),
          capitulo("Das alterações"),
          paragrafo(
              "A presente versão desta Política de Privacidade foi atualizada pela última vez em: 20/09/2020.\nO editor se reserva o direito de modificar, a qualquer momento o aplicativo as presentes normas, especialmente para adaptá-las às evoluções do Ecores, seja pela disponibilização de novas funcionalidades, seja pela supressão ou modificação daquelas já existentes.\nO usuário será explicitamente notificado em caso de alteração desta política.\nAo utilizar o serviço após eventuais modificações, o usuário demonstra sua concordância com as novas normas. Caso discorde de alguma das modificações, deverá pedir, imediatamente, o cancelamento de sua conta e apresentar a sua ressalva ao serviço de atendimento, se assim o desejar."),
          capitulo("10. Do Direito aplicável e do foro"),
          paragrafo(
              "Para a solução das controvérsias decorrentes do presente instrumento, será aplicado integralmente o Direito brasileiro.\nOs eventuais litígios deverão ser apresentados no foro da comarca em que se encontra a sede do editor do aplicativo."),
        ],
      ),
    );
  }
}

class capitulo extends StatelessWidget {
  final String texto;
  const capitulo(this.texto);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ));
  }
}

class paragrafo extends StatelessWidget {
  final String texto;
  const paragrafo(this.texto);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          texto,
          style: const TextStyle(fontSize: 15),
          textAlign: TextAlign.justify,
        ));
  }
}

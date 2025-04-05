
const String imageAppFirst = "assets/app/six.png";
const String imageIcon = "assets/app/icone.png";
const String imageError =  "assets/app/nao-perfil.gif";

///SOUNDS
const String nameClipBut = 'click-button.wav';
const String nameClipCodeBar = 'codigo-barras.wav';
const String nameClipError = 'erro.wav';
const String nameClipSuccess = 'BeepBeep_high.wav';
const String nameClipWarning = 'AlertWar.wav';
const String nameClipInfo = 'infor.wav';

///SpeechScreenController
const String labelButRemoveDataBase = 'APAGAR';
const String labelButSaveDataBase = 'SALVAR';
const String labelButEditeDataBase = 'EDITAR';
const String labelButGeneratorPdfDataBase = 'GERAR PDF';
const String labelHelpNameSaveSpeechScreenController = "Salvar com qual Nome?";
const String labelLegendTitleSaveSpeechScreenController = 'SALVAR COMO';
const String labelLegendSaveSpeechScreenController = "Defina um nome para Salvar Esse Arquivo.";
const String labelErrorNameSaveSpeechScreenController = 'Nome Inválido.';
const String labelCountCharactersSpeechScreenController = "Caracteres:";
const String labelVisibilityCharactersSpeechScreenController = "Visibilidade:";
const String appNameNewDocument = "NOVO ARQUIVO";
const String labelExitNoSaveSpeechScreenController = "TEM CERTEZA QUE DESEJA SAIR SEM SALVAR?";
const String labelExitNoSaveConfirmSpeechScreenController = "SIM, SAIR AGORA";
const String labelExitNoSaveNotExitSpeechScreenController = "NÃO, CONTINUAR";
const String labelErrorStartRecover ="Erro Ao Iniciar Gravação: ";
const String labelWaitSpeechScreenController = "Aguarde,Finalizando Operação";
const String labelSaveWithSuccess = "Documento Salvo com Sucesso!";
const String labelRemoveWithSuccess = "Documento Apagado com Sucesso!";

const String labelLegendTitleRemoveSpeechScreenController = 'APAGAR DOCUMENTO';
const String labelLegendRemoveSpeechScreenController = "Tem Certeza que Deseja Apagar esse Arquivo";

const String labelLegendTitleEditeSpeechScreenController = 'EDITAR AGORA?';
const String labelLegendEditeSpeechScreenController = "Tem Certeza que Deseja Editar esse Arquivo?";

const String labelButPrivateName = 'PRIVADO';
const String labelButPublicName = 'PÚBLICO';
const String labelButLinkName = 'LINKS';
const String labelButLinkToVideoName = 'LINK DE VÍDEOS';
const String labelButAudioRecorderVideoName = 'GRAVAR ÁUDIO';
const String labelButAudioVideoName = 'ÁUDIO';
const String labelButSpeechToTextName = 'ÁUDIO PARA TEXTO';

const String labelButStop= 'PARAR';
const String labelButPauseStop= 'PAUSER';
const String labelButResumeStop= 'CONTINUAR';
const String labelButPlayRecorder= 'GRAVAR';

///CreatePdf
const String labelErrorPdf = "Ocorreu o Seguinte Erro ao Gerar o PDF: ";

///FirebaseDocuments
const String labelErrorFindDocumentsFirebaseDocuments = "Ocorreu o Seguinte Erro ao Buscar Documentos no Banco de Dados: ";
const String labelErrorGetListWithFilterFirebaseDocuments = "Ocorreu o Seguinte Erro ao Gerar a Lista com os Documentos: ";
const String labelErrorSaveFirebaseDocuments = "Ocorreu o Seguinte Erro ao Salvar o Documentos: ";
const String labelErrorRemoveFirebaseDocuments = "Ocorreu o Seguinte Erro ao Remover os Documentos: ";

///FirebaseCreateUsers
const String labelErrorSaveFirebaseUser = "Ocorreu o Seguinte Erro ao Salvar o Usuario: ";

///Statics
const String nameOk ="OK";
const String labelNoHasNet ='SEM INTERNET';
const String labelNoHasNetDescription ='Você Não Tem Acesso a Internet, Tente Reconectar.';
const String labelErrorForce ='ERRO';

///CRATE NEW USER
const String labelTopCreateNewUser ="CRIAR NOVO USUÁRIO";
const String labelWaitCreateNewUser = "Criando o Seu Perfil, Aguarde...";
const String labelButCreateNewUser ="CRIAR PERFIL";
const String labelErrorFormCreateUser ="Você Precisa Completar Corretamente Todos os Campos de Texto!";
const String labelErrorCheckTermServiceCreateUser ="Você Precisa Aceitar os Termos de Serviço!";
const String labelErrorKeyCodeNoEqualsFormCreateUser ="As Senhas Não São Iguais, Confira e Tente Novamente!";
const String labelErrorFirebaseCreateUser ="E-mail ou Senha está Inválido";
const String labelTitlePageCreateNewUser = "CONFIGURE SEUS DADOS DE ACESSO";
const String labelHelpInputKeyCodeCreateNewUser= 'Criar Senha...';
const String labelHelpInputEmailCreateNewUser= 'Seu E-mail...';
const String labelHelpInputNameUserNewUser= 'Nome do Perfil...';
const String labelHelpInputNameCompleteUserNewUser= 'Nome Completo...';
const String labelHelpInputDescriptionSortUserNewUser= 'Sua Descrição Curta...';
const String labelHelpInputDescriptionLargeUserNewUser= 'Sua Descrição Completa...';
const String labelHelpInputInstUserNewUser= 'Url da Image de Perfil do Facebook ou Outra...';

const String labelHelpInputCheckKeyCodeCreateNewUser= 'Repita a Senha...';
const String labelErrorKeyCodeCreateNewUser= 'Não São Iguais';
const String labelErrorNameCreateNewUser = 'Informe mais dados';
const String labelErrorOpenTermService ="Erro Ao Abrir Link Url com os Termos de Serviço!";
const String labelTermServices ="Concordo Com os Termos de Serviço";

///ResetCodeKeyScreen
const String labelResetKeyScreenTopMenu = 'RECUPERAR SENHA';
const String labelEmailInvalidResetKeyScreen= 'E-mail Não é Válido!';
const String labelButSendCodeResetKeyScreenTopMenu = 'Enviar Código';
const String labelTitlePageResetKeyScreen = "Recuperar Senha de Acesso.";

const String labelCodeMessageResetKeyScreen = "O Link de Recuperação foi Enviado para o Seu E-mail, Vérifique a Caixa de Spam";
const String labelButCheckCodeResetKeyScreen = "VERIFICAR CÓDIGO";

const String labelHelpCodeResetResetKeyScreen = "Código de Recuperação...";

const String labelCancel = "CANCELAR";
const String labelAttention = "ATENÇÃO";

///SettingsScreen
const String labelNameSettingsScreen = "CONFIGURAÇÕES DE PESSOAIS";
const String labelEditeSuccessSettingsScreen = "Dados Editados Com Sucesso";
const String labelFollowersSettingsScreen = "Seguidores";
const String labelFollowedSettingsScreen = "Seguindo";

///SearchScreen
const String labelNameSearchScreen = "PESQUISAR USÚARIOS";
const String labelNotSearchScreen= "Não ha Usuários Cadastrados...";
const String labelNotSearchScreenBaseWithFilter = "Não Existem Usuários com Esse Filtro...";

///ListWithTextSaveScreen
const String labelTopListText = "BUSCAR ARQUIVO TRANSCRITO";
const String labelFilterFindListText = "Buscar...";
const String labelNotItemsInBase = "Não Tem Documentos Salvos, Crie um Agora...";

const String labelNotPublicItemsInBase = "Não Tem Documentos Publicos...";
const String labelNotPublicInBaseWithFilter = "Não Existem Documentos Publics com Esse Filtro...";

const String labelNotItemsInBaseWithFilter = "Não Existem Documentos com Esse Filtro...";
const String labelWaitFindItems = "Buscado Arquivos no Banco de Dados, Aguarde...";
const String labelWaitPdf = "Gerando Pdf, Aguarde...";

const String labelWait = "Buscando no Banco de Dados, Aguarde....";

const String labelSearch = "Pesquisar";
const String labelFiles = "Arquivos";
const String labelSubscribe = "Inscrições";
const String labelSettings = "Configurar";

///ViewStudyScreen
const String labelNameViewStudyScreen = "ARQUIVOS PUBLICOS";
const String labelButFollowViewStudyScreen = "SEGUIR";
const String labelButUnFollowViewStudyScreen = "UNFOLLOW";
/// LABELS
const String appName = "SIX";
const String labelErrorNotNet = "NÃO TEM ACESSO A INTERNET";
const String version = '®Mushroom Angels Games 2018-2022 | Version 1.0.0';

///AutenticacaoController
const String labelDescriptionErrorLogin = "Erro ao Conectar ao Servidor: ";

/// - CODE ->  AutenticacaoPage
const String labelWaitLoginDataBase = "Logando No Servidor...";
const String labelHelpInputEmail = 'Email';
const String labelButCreateAccount = 'CRIAR CONTA';
const String labelForgetCodeKey = "RECUPERA SENHA";
const String labelErrorEmail = 'Informe o Email Corretamente!';
const String labelHelpInputKeyCode= 'Senha';
const String labelErrorNoEditeKeyCode = 'Informe sua Senha!';
const String labelErrorLessKeyCode = 'Sua Senha Deve Ter no Mínimo 6 Caracteres';

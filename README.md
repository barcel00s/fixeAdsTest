# fixeAdsTest

Desafio:

Este desafio consiste em criar uma aplicação universal (iPad/iPhone) que seja capaz de:
* Fazer o seguinte pedido à API: : https://olx.pt/i2/ads/?json=1&search[category_id]=25
* Representar a informação devolvida em modo de listagem e modo de detalhe
* A partir do modo de detalhe, deve ser possível aceder a uma vista de mapa e a uma vista dedicada para as fotos.
* Deve ser possível navegar entre detalhes de vários anúncios usando um UIPageViewController.
* A partir do modo de listagem, deve ser possível partilhar informação de cada um dos anúncios.
* Deve existir uma forma de persistir os dados recebidos.


Exemplo de utilização:

Assim que é carregada, esta aplicação apresenta uma tabela com todos os anúncios disponíveis no link, bem como todos os outros já carregados anteriormente.

Sempre que a app recebe um novo anúncio, guarda o registo do anúncio e das suas fotos em duas tabelas distintas (no Core Data), sendo que as imagens apenas são descarregadas à medida que são requisitadas pelo utilizador, de forma a reduzir o consumo de dados móveis. As imagens são importadas por ordem de slot_id e posteriormente devolvidas nessa ordem pelo core data de forma a que sejam apresentadas sempre por essa ordem.

A partir desta tabela o utilizador pode partilhar o anúncio através de e-mail, mensagem ou nas suas contas de redes sociais associadas ao dispositivo.

Seleccionando um dos anúncios o utilizador pode ver mais informações (titulo, cidade, preço, se preço é negociável, descrição e o nome do utilizador do anunciante) bem como todas as suas imagens.
A visualização das imagens pode ser feita fazendo scroll directamente ou seleccionando qualquer uma delas para as poder visualizar em ecrã completo.
A partir daqui também é possível consultar a geolocalização do anúncio seleccionando a opção para ver o anúncio no mapa.

A aplicação pode funcionar completamente em modo offline sendo apenas possível consultar eventos já carregados na base de dados.

A aplicação está ainda preparada para se adaptar ao tamanho de fonte seleccionada pelo o utilizador nas definições do dispositivo(General -> Acessibilility -> Large Text) , embora devido a um bug do simulador do iOS 9.3, apenas é possível testar esta funcionalidade com um dispositivo real. 


Bibliotecas iOS utilizadas:
MapKit,
Core Data

Bliblitecas de 3ºs utilizadas (via CocoaPods):
FontAwesomeKit - https://github.com/PrideChung/FontAwesomeKit


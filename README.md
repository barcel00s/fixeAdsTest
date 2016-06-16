# fixeAdsTest

Desafio:

Este desafio consiste em criar uma aplicação universal (iPad/iPhone) que seja capaz de:
* Fazer o seguinte pedido à API: : https://olx.pt/i2/ads/?json=1&search[category_id]=25
* Representar a informação devolvida em modo de listagem e modo de detalhe
* A partir do modo de detalhe, deve ser possível aceder a uma vista de mapa e a uma vista dedicada para as fotos.
* Deve ser possível navegar entre detalhes de vários anúncios usando um UIPageViewController.
* A partir do modo de listagem, deve ser possível partilhar informação de cada um dos anúncios.
* Deve existir uma forma de persistir os dados recebidos.

Funcionalidade extra:
 - Mostrar anúncios do utilizador
 - Fontes dinâmicas
 


Exemplo de utilização:

iPhone

Assim que é carregada, esta aplicação apresenta uma tabela com todos os anúncios disponíveis no link, bem como todos os outros já carregados anteriormente.

Sempre que a app recebe um novo anúncio, guarda a informação (Core Data) em 3 tabelas distintas, uma para o anúncio, outra para as fotos e outra para os utilizadores. No entanto, as imagens não são descarregadas imediatamente mas sim à medida que são requisitadas pelo utilizador, de forma a reduzir o consumo de dados móveis. 

As imagens são importadas por ordem de slot_id e posteriormente devolvidas nessa ordem pelo Core Data

A partir desta tabela na view principal o utilizador pode partilhar o anúncio através de e-mail, mensagem ou nas suas contas de redes sociais associadas ao dispositivo.

Seleccionando um dos anúncios o utilizador pode ver mais informações (titulo, cidade, preço, se preço é negociável, descrição e o nome do utilizador do anunciante) bem como todas as suas imagens.

A navegação nas imagens é feita através de scroll horizontal directamente. Também é possível visualizá-las (e navegar) em ecrã completo, seleccionando uma das imagens. (PageViewController)

A navegação nos anúncios também pode ser feita através de scroll horizontal. (PageViewController)

A partir desta view também é possível consultar a geolocalização do anúncio seleccionando a opção para ver o anúncio no mapa.

Também é possível consultar todos os anúncios de cada utilizador e não só apenas aqueles já carregados na app, mas também os que existem no servidor já que a app consulta o servidor em busca de novos anúncios para esse utilizador, guardando-os caso ainda não existam no dispositivo.

Ao seleccionar um destes anúncios do utilizador a app muda a lista de anúncios actual e passa a utilizar a lista de anúncios do utilizador na navegação entre anúncios. Selecionando outro anúncio na tabela principal volta à lista principal.


iPad

Em iPad a app tem um comportamento ligeiramente diferente. É apresentado um splitViewController na abertura, com a listagem de anúncios num menu lateral e é na view principal que é apresentado cada anúncio. O mapa é apresentado num PopOver, bem como os anúncios do utilizador de forma a tirar mais proveito do tamanho do ecrã.

A aplicação pode funcionar completamente em modo offline sendo, neste caso, apenas possível consultar eventos já carregados na base de dados.

A aplicação está ainda preparada para se adaptar ao tamanho de fonte seleccionada pelo o utilizador nas definições do dispositivo(General -> Acessibilility -> Large Text) , embora devido a um bug do simulador do iOS 9.3, apenas é possível testar esta funcionalidade com um dispositivo real. 



Bibliotecas iOS utilizadas:
MapKit,
Core Data

Bliblitecas de 3ºs utilizadas (via CocoaPods):
FontAwesomeKit - https://github.com/PrideChung/FontAwesomeKit


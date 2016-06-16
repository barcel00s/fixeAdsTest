# fixeAdsTest

Este desafio consiste em criar uma aplicação universal (iPad/iPhone) que seja capaz de:
* Fazer o seguinte pedido à API: : https://olx.pt/i2/ads/?json=1&search[category_id]=25
* Representar a informação devolvida em modo de listagem e modo de detalhe
* A partir do modo de detalhe, deve ser possível aceder a uma vista de mapa e a uma vista dedicada para as fotos.
* Deve ser possível navegar entre detalhes de vários anúncios usando um UIPageViewController.
* A partir do modo de listagem, deve ser possível partilhar informação de cada um dos anúncios.
* Deve existir uma forma de persistir os dados recebidos.


Assim que é carregada, esta aplicação apresenta uma tabela com todos os anúncios disponíveis no link, bem como todos os outros já carregados anteriormente.
Sempre que a app recebe um novo anúncio, guarda o registo do anúncio e das suas fotos em duas tabelas distintas (no Core Data), sendo que as imagens apenas descarregadas à medida que são requisitadas pelo utilizador.

A partir desta tabela o utilizador pode partilhar o anúncio através de e-mail, mensagem ou nas redes sociais associadas ao dispositivo.

Seleccionando um dos anúncios o utilizador pode ver mais informações sobre este bem como todas as imagens associadas ao anúncio, fazendo scroll nas imagens ou seleccionando qualquer uma delas para as poder visualizar em ecrã completo.

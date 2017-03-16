--Nombre de clients
SELECT COUNT(CLI_ID)
FROM T_CLIENT;

--Les clients triés sur le titre et le nom
Select *
FROM T_CLIENT
order by TIT_CODE,CLI_NOM ASC;

--Les clients triés sur le libellé du titre et le nom

Select CLI_ID,CLI_NOM,CLI_PRENOM,T_CLIENT.TIT_CODE,TIT_LIBELLE FROM T_CLIENT,T_TITRE
WHERE T_CLIENT.TIT_CODE=T_TITRE.TIT_CODE
order by TIT_LIBELLE,CLI_NOM ASC;

--Les clients commençant par 'B'
SELECT *
FROM T_CLIENT
WHERE CLI_NOM like 'B%';

--Les clients homonymes
SELECT  CLI_NOM
FROM     T_CLIENT
GROUP BY CLI_NOM
HAVING   COUNT(CLI_NOM) > 1

--Nombre de titres différents
SELECT COUNT(TIT_CODE)
FROM T_TITRE;

--Nombre d'enseignes
SELECT COUNT(distinct CLI_ENSEIGNE)
FROM T_CLIENT;

--Les clients qui représentent une enseigne
SELECT *
FROM T_CLIENT
WHERE CLI_ENSEIGNE is not null ;
--Les clients qui représentent une enseigne de transports
SELECT *
FROM T_CLIENT
WHERE CLI_ENSEIGNE is not null
AND UPPER(CLI_ENSEIGNE) like UPPER("%transport%");

--Nombre d'hommes,Nombres de femmes, de demoiselles, Nombres de sociétés
SELECT TIT_CODE,COUNT(CLI_ID)
FROM T_CLIENT
GROUP BY TIT_CODE;
	--manque le nombre d'enseigne

--Nombre d''emails
SELECT COUNT(EML_ID)
FROM T_EMAIL;

--Client sans email 
SELECT CLI_ID,CLI_NOM,CLI_PRENOM
FROM T_CLIENT
WHERE CLI_ID not in ( SELECT CLI_ID FROM T_EMAIL);

--Clients sans téléphone 
SELECT CLI_ID,CLI_NOM,CLI_PRENOM
FROM T_CLIENT
WHERE CLI_ID not in ( SELECT CLI_ID FROM T_TELEPHONE);

--Les phones des clients
SELECT T_CLIENT.CLI_ID,CLI_NOM,CLI_PRENOM,TEL_NUMERO
FROM T_CLIENT,T_TELEPHONE
WHERE T_CLIENT.CLI_ID=T_TELEPHONE.CLI_ID 
order by T_CLIENT.CLI_ID;
--Ventilation des phones par catégorie
SELECT  TYP_CODE,COUNT(TEL_ID)
FROM     T_TELEPHONE
GROUP BY TYP_CODE;

--Les clients ayant plusieurs téléphones
SELECT  CLI_ID,COUNT(TEL_ID)
FROM     T_TELEPHONE
GROUP BY CLI_ID
HAVING   COUNT(CLI_ID) > 1

--Clients sans adresse:
SELECT CLI_ID,CLI_NOM,CLI_PRENOM
FROM T_CLIENT
WHERE CLI_ID not in ( SELECT CLI_ID FROM T_ADRESSE);

--Clients sans adresse mais au moins avec mail ou phone 
SELECT CLI_ID,CLI_NOM,CLI_PRENOM
FROM T_CLIENT
WHERE ((CLI_ID not in ( SELECT CLI_ID FROM T_ADRESSE))
AND ((CLI_ID in ( SELECT CLI_ID FROM T_EMAIL))
OR (CLI_ID in ( SELECT CLI_ID FROM T_TELEPHONE))))
order by CLI_ID ASC;

--Dernier tarif renseigné
SELECT *
FROM T_TARIF
WHERE TRF_DATE_DEBUT=(SELECT MAX(TRF_DATE_DEBUT) FROM T_TARIF);

--Tarif débutant le plus tôt
SELECT *
FROM T_TARIF
WHERE TRF_DATE_DEBUT=(SELECT MIN(TRF_DATE_DEBUT) FROM T_TARIF);

--Différentes Années des tarifs
SELECT distinct strftime('%Y',TRF_DATE_DEBUT)
FROM T_TARIF;

--Nombre de chambres de l'hotel
SELECT COUNT(CHB_ID)
FROM T_CHAMBRE;

--Nombre de chambres par étage
SELECT CHB_ETAGE,COUNT(CHB_ID)
FROM T_CHAMBRE
GROUP BY CHB_ETAGE;

--Chambres sans telephone
SELECT *
FROM T_CHAMBRE
WHERE CHB_POSTE_TEL not null;

--Existence d'une chambre n°13 ?
SELECT *
FROM T_CHAMBRE
WHERE CHB_NUMERO=13;

--Chambres avec sdb
SELECT *
FROM T_CHAMBRE
WHERE CHB_BAIN=1 OR CHB_DOUCHE=1;

--Chambres avec douche
SELECT *
FROM T_CHAMBRE
WHERE CHB_DOUCHE=1;

--Chambres avec WC
SELECT *
FROM T_CHAMBRE
WHERE CHB_WC=1;

--Chambres sans WC séparés
SELECT *
FROM T_CHAMBRE
WHERE CHB_WC=0;

--Quels sont les étages qui ont des chambres sans WC séparés ?
SELECT CHB_ETAGE
FROM T_CHAMBRE
WHERE CHB_ID in (SELECT CHB_ID FROM T_CHAMBRE WHERE CHB_WC=0);

--Nombre d'équipements sanitaires par chambre trié par ce nombre d'équipement croissant

--Chambres les plus équipées et leur capacité
SELECT CHB_ID,CHB_COUCHAGE
FROM T_CHAMBRE
WHERE CHB_BAIN=1 AND CHB_DOUCHE=1 AND CHB_WC=1;

--Repartition des chambres en fonction du nombre d'équipements et de leur capacité

--Nombre de clients ayant utilisé une chambre
SELECT COUNT(distinct CLI_ID)
FROM TJ_CHB_PLN_CLI;

--Clients n'ayant jamais utilisé une chambre (sans facture)
SELECT COUNT(distinct CLI_ID)
FROM T_FACTURE
where CLI_ID not in (SELECT CLI_ID FROM T_FACTURE);

--Nom et prénom des clients qui ont une facture
SELECT distinct CLI_NOM, CLI_PRENOM
FROM T_CLIENT
WHERE CLI_ID in ( SELECT distinct CLI_ID FROM T_FACTURE);

--Nom, prénom, telephone des clients qui ont une facture
SELECT distinct CLI_NOM, CLI_PRENOM,TEL_NUMERO
FROM T_CLIENT,T_TELEPHONE
WHERE T_CLIENT.CLI_ID in ( SELECT distinct CLI_ID FROM T_FACTURE)
AND T_CLIENT.CLI_ID=T_TELEPHONE.CLI_ID;

--Attention si email car pas obligatoire : jointure externe

--Adresse où envoyer factures aux clients

--Répartition des factures par mode de paiement (libellé)
SELECT PMT_LIBELLE,COUNT(FAC_ID)
FROM T_FACTURE,T_MODE_PAIEMENT
WHERE T_FACTURE.PMT_CODE=T_MODE_PAIEMENT.PMT_CODE
GROUP BY T_FACTURE.PMT_CODE;

--Répartition des factures par mode de paiement
SELECT PMT_CODE,COUNT(FAC_ID)
FROM T_FACTURE
GROUP BY PMT_CODE;

--Différence entre ces 2 requêtes ? 
-- DANS la première on est obligé de faire une jointure pour accéder au libellé
-- alors que ddans la deuxième elle n'est pas nécessaire

--Factures sans mode de paiement 
SELECT *
FROM T_FACTURE
WHERE PMT_CODE is null;

--Repartition des factures par Années
SELECT strftime('%Y',FAC_DATE),COUNT(FAC_ID)
FROM T_FACTURE
GROUP BY strftime('%Y',FAC_DATE);

--Repartition des clients par ville
SELECT ADR_VILLE,COUNT(CLI_ID)
FROM T_ADRESSE
GROUP BY ADR_VILLE;

--Montant TTC de chaque ligne de facture (avec remises)

--Classement du montant total TTC (avec remises) des factures

--Tarif moyen des chambres par années croissantes

--Tarif moyen des chambres par étage et années croissantes

--Chambre la plus cher et en quelle année

--Chambre la plus cher par année 

--Clasement décroissant des réservation des chambres 

--Classement décroissant des meilleurs clients par nombre de réservations

--Classement des meilleurs clients par le montant total des factures

--Factures payées le jour de leur édition
SELECT * 
FROM T_FACTURE
WHERE FAC_PMT_DATE-FAC_DATE=0;

--Facture dates et Délai entre date de paiement et date d'édition de la facture
SELECT FAC_ID,FAC_DATE,FAC_PMT_DATE-FAC_DATE
FROM T_FACTURE;
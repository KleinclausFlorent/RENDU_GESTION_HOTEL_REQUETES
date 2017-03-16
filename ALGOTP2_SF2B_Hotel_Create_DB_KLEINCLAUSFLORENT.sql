

create  table T_CHAMBRE ( 	CHB_ID integer(12) not null,
							CHB_NUMERO integer (3) not null,
							CHB_ETAGE char (3) not null,
							CHB_BAIN integer (1) not null,
							CHB_DOUCHE integer (1) not null,
							CHB_WC integer (1) not null,
							CHB_COUCHAGE int (3) not null,
							CHB_POSTE_TEL char(3),
						primary key (CHB_ID));
									
create table T_TARIF ( 	TRF_DATE_DEBUT date not null,
						TRF_TAUX_TAXES decimal(12,2) not null,
						TRF_PETIT_DEJEUNE money(12) not null,
					primary key (TRF_DATE_DEBUT));


create table TJ_CHB_TRF ( TRF_CHB_PRIX money (12) not null,
						  CHB_ID integer(12) not null,
						  TRF_DATE_DEBUT date not null,
						primary key (TRF_CHB_PRIX,CHB_ID),
						foreign key (CHB_ID) references T_CHAMBRE(CHB_ID)
						 on delete no action on update cascade,
						foreign key (TRF_DATE_DEBUT) references T_TARIF(TRF_DATE_DEBUT)
						 on delete no action on update cascade);


create table T_PLANNING (  PLN_JOUR date not null,
						primary key (PLN_JOUR));

create table T_TITRE ( 	TIT_CODE char(8) not null,
						TIT_LIBELLE varchar(32) not null,
					primary key (TIT_CODE));

create table T_TYPE ( 	TYP_CODE char(8) not null,
						TYP_LIBELLE varchar(32) not null,
					primary key (TYP_CODE));

create table T_MODE_PAIEMENT ( 	PMT_CODE char(8) not null,
								PMT_LIBELLE varchar(64) not null,
							primary key (PMT_CODE));

create table T_CLIENT ( CLI_ID integer(12) not null,
						CLI_NOM char(32) not null,
						CLI_PRENOM varchar(25) not null,
						CLI_ENSEIGNE varchar(100),
						TIT_CODE char(8) not null,
					primary key (CLI_ID),
					foreign key (TIT_CODE) references T_TITRE(TIT_CODE)
					 on delete no action on update cascade);

create table T_FACTURE ( 	FAC_ID integer(12) not null,
							FAC_DATE date not null,
							CLI_ID integer(12) not null,
							FAC_PMT_DATE date not null,
							PMT_CODE char(8) not null,
						primary key (FAC_ID),
						foreign key (PMT_CODE) references T_MODE_PAIEMENT(PMT_CODE)
						 on delete no action on update cascade,
						foreign key (CLI_ID) references T_CLIENT(CLI_ID)
						 on delete no action on update cascade);

create table T_ADRESSE ( 	ADR_ID integer(12) not null,
							ADR_LIGNE1 varchar(32) not null,
							ADR_LIGNE2 varchar(32) not null,
							ADR_LIGNE3 varchar(32) not null,
							ADR_LIGNE4 varchar(32) not null,
							ADR_CP char(5) not null,
							ADR_VILLE char(32) not null,
							CLI_ID integer(12) not null,
						primary key (ADR_ID),
						foreign key (CLI_ID) references T_CLIENT(CLI_ID)
						 on delete no action on update cascade); 

create table T_EMAIL ( 	EML_ID integer(12) not null,
						EML_ADRESSE varchar(100) not null,
						EML_LOCALISATION varchar(64) not null,
						CLI_ID integer(12) not null,
					primary key (EML_ID),
					foreign key (CLI_ID) references T_CLIENT(CLI_ID)
					 on delete no action on update cascade);

create table T_TELEPHONE ( 	TEL_ID integer(12) not null,
							TEL_NUMERO char(20) not null,
							TEL_LOCALISATION varchar(64) not null,
							CLI_ID integer(12) not null,
							TYP_CODE char(8) not null,
						primary key (TEL_ID),
						foreign key (CLI_ID) references T_CLIENT(CLI_ID)
						 on delete no action on update cascade,
						foreign key (TYP_CODE) references T_TYPE(TYP_CODE)
						 on delete no action on update cascade);

create table T_LIGNE_FACTURE ( 	LIF_ID integer(12) not null,
								LIF_QTE decimal(5,2) not null,
								LIF_REMISE_POURCENT decimal(5,2),
								LIF_REMISE_MONTANT money(12),
								LIF_MONTANT money(12) not null,
								LIF_TAUX_TVA decimal(12,2) not null,
								FAC_ID integer(12) not null,
							primary key (LIF_ID),
							foreign key (FAC_ID) references T_FACTURE(FAC_ID)
							 on delete no action on update cascade);


create table TJ_CHB_PLN_CLI ( 	CHB_PLN_CLI_NB_PERS integer(12) not null,
								CHB_PLN_CLI_RESERVE integer(12) not null,
								CHB_PLN_CLI_OCCUPE integer(12) not null,
								CHB_ID integer(12) not null,
								PLN_JOUR date not null,
								CLI_ID integer (12) not null,
							primary key (CHB_ID,PLN_JOUR),
							foreign key (CHB_ID) references T_CHAMBRE(CHB_ID)
							 on delete no action on update cascade,
							foreign key (PLN_JOUR) references T_PLANNING(PLN_JOUR)
							 on delete no action on update cascade,
							foreign key (CLI_ID) references T_CLIENT(CLI_ID)
							 on delete no action on update cascade);
							



													
create unique index XCHB_CHB_ID on T_CHAMBRE(CHB_ID);
create unique index XPLANNING_PLN_JOUR on T_PLANNING(PLN_JOUR);
create unique index XCLIENT_CLI_ID on T_CLIENT(CLI_ID);
create unique index XTITRE_TIT_CODE on T_TITRE(TIT_CODE);
create unique index XADRESSE_ADR_ID on T_ADRESSE(ADR_ID);
create unique index XTARIF_TRF_DATE_DEBUT on T_TARIF(TRF_DATE_DEBUT);
create unique index XEMAIL_EML_ID on T_EMAIL(EML_ID);
create unique index XTYPE_TYP_CODE on T_TYPE(TYP_CODE);
create unique index XTELEPHONE_TEL_ID on T_TELEPHONE(TEL_ID);
create unique index XFACTURE_FAC_ID on T_FACTURE(FAC_ID);
create unique index XMODE_PAIEMENT on T_MODE_PAIEMENT(PMT_CODE);
create unique index XLIGNE_FACTURE_LIF_ID on T_LIGNE_FACTURE(LIF_ID);
create unique index XTJ_CHB_PLN_CLI_CHB_PLN_CLI_NB_PERS on TJ_CHB_PLN_CLI(CHB_PLN_CLI_NB_PERS);
create unique index XTJ_CHB_TRF_TRF_CHB_PRIX on TJ_CHB_TRF(TRF_CHB_PRIX);
create unique index XTJ_PMT_FAC_FAC_PMT_DATE on TJ_PMT_FAC(FAC_PMT_DATE);
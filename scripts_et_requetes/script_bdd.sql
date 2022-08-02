
CREATE SEQUENCE public.cadastre_cadastre_id_seq;

CREATE TABLE public.cadastre (
                cadastre_id INTEGER NOT NULL DEFAULT nextval('public.cadastre_cadastre_id_seq'),
                code_type_voie SMALLINT NOT NULL,
                code_voie VARCHAR(20) NOT NULL,
                code_id_commune INTEGER NOT NULL,
                prefixe_section INTEGER,
                section VARCHAR(30),
                numero_plan SMALLINT NOT NULL,
                nature_culture VARCHAR(20),
                nature_culture_speciale VARCHAR(20),
                surface_terrain INTEGER,
                CONSTRAINT cadastre_pk PRIMARY KEY (cadastre_id)
);


ALTER SEQUENCE public.cadastre_cadastre_id_seq OWNED BY public.cadastre.cadastre_id;

CREATE SEQUENCE public.adresse_adresse_id_seq;

CREATE TABLE public.adresse (
                adresse_id INTEGER NOT NULL DEFAULT nextval('public.adresse_adresse_id_seq'),
                type_voie VARCHAR(30),
                nom_voie VARCHAR(30) NOT NULL,
                code_postal INTEGER NOT NULL,
                nom_commune VARCHAR(50) NOT NULL,
                code_departement VARCHAR(10) NOT NULL,
                CONSTRAINT adresse_pk PRIMARY KEY (adresse_id)
);


ALTER SEQUENCE public.adresse_adresse_id_seq OWNED BY public.adresse.adresse_id;

CREATE SEQUENCE public.vente_vente_id_seq;

CREATE TABLE public.vente (
                vente_id INTEGER NOT NULL DEFAULT nextval('public.vente_vente_id_seq'),
                date_mutation TIMESTAMP NOT NULL,
                nature_mutation VARCHAR(30) NOT NULL,
                valeur_fonciere NUMERIC(10,2),
                CONSTRAINT vente_pk PRIMARY KEY (vente_id)
);


ALTER SEQUENCE public.vente_vente_id_seq OWNED BY public.vente.vente_id;

CREATE SEQUENCE public.bien_bien_id_seq;

CREATE TABLE public.bien (
                bien_id INTEGER NOT NULL DEFAULT nextval('public.bien_bien_id_seq'),
                numero_disposition SMALLINT NOT NULL,
                lot_1_numero VARCHAR(30),
                lot_1_surface_carrez NUMERIC(10,2) NOT NULL,
                nombre_lots SMALLINT NOT NULL,
                type_local VARCHAR(30) NOT NULL,
                surface_reelle_bati INTEGER NOT NULL,
                nombre_pieces_principales INTEGER NOT NULL,
                numero_voie SMALLINT,
                indice_de_repetition VARCHAR(20),
                adresse_id INTEGER NOT NULL,
                cadastre_id INTEGER NOT NULL,
                vente_id INTEGER NOT NULL,
                CONSTRAINT bien_pk PRIMARY KEY (bien_id)
);


ALTER SEQUENCE public.bien_bien_id_seq OWNED BY public.bien.bien_id;

ALTER TABLE public.bien ADD CONSTRAINT cadastre_bien_fk
FOREIGN KEY (cadastre_id)
REFERENCES public.cadastre (cadastre_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.bien ADD CONSTRAINT adresse_bien_fk
FOREIGN KEY (adresse_id)
REFERENCES public.adresse (adresse_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.bien ADD CONSTRAINT mutation_bien_fk
FOREIGN KEY (vente_id)
REFERENCES public.vente (vente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

# Tekniq Hulp

Tekniq Hulp is de door Tekniq aangepaste Windows-client voor hulp op afstand.
De client is gebaseerd op RustDesk 1.4.9 en verbindt standaard met de door
Tekniq beheerde ID- en relayserver.

## Bron en wijzigingen

- Basis: RustDesk 1.4.9, commit `6c578292e8ebbbec708b76986ba8c4bc7c509747`.
- Tekniq-branche: `tekniq-hulp-1.4.9`.
- De Tekniq-wijzigingen staan als normale Git-commits boven op de upstream-tag.
- De servernaam en openbare encryptiesleutel worden tijdens de build toegepast
  door `scripts/apply-tekniq-branding.ps1`.
- De reproduceerbare Windows-build staat in
  `.github/workflows/build-tekniq-hulp.yml`.

## Licentie

De RustDesk-bron en deze afgeleide client worden aangeboden onder de GNU Affero
General Public License versie 3 zoals opgenomen in `LICENCE`. Bestaande
copyrightvermeldingen van RustDesk en andere rechthebbenden blijven behouden.

## Privacy en ondersteuning

De client maakt alleen op verzoek van de gebruiker verbinding voor hulp op
afstand. De gebruiker ziet de sessie en kan deze beëindigen door de client te
sluiten. Zie `https://help.tekniq.nl/hulp-op-afstand` voor de actuele uitleg.

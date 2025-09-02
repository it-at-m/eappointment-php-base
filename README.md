<div id="top"></div>

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

# E-Appointment PHP Base
Infrastructure Foundation: eappointment-php-base provides standardized PHP runtime environments for eappointment [build](https://github.com/it-at-m/eappointment/blob/main/.github/workflows/php-build-images.yaml#L43) via the [Containerfile](https://github.com/it-at-m/eappointment/blob/main/.resources/Containerfile).

```mermaid
%%{init: {"flowchart": {"defaultRenderer":"elk"}}}%%
graph TD
    %% Infrastructure Foundation
    subgraph InfrastructureFoundation["Infrastructure Foundation"]
        PHPBASE["eappointment-php-base<br>🐳 PHP Docker Base Images<br>Runtime Environment"]
    end

    %% Main ZMS module dependencies
    zmsapi --> zmsslim
    zmsapi --> zmsclient
    zmsapi --> zmsdldb
    zmsapi --> zmsdb
    zmsapi --> zmsentities

    zmsadmin --> mellon
    zmsadmin --> zmsclient
    zmsadmin --> zmsslim
    zmsadmin --> zmsentities

    zmscalldisplay --> mellon
    zmscalldisplay --> zmsclient
    zmscalldisplay --> zmsentities
    zmscalldisplay --> zmsslim

    zmsstatistic --> mellon
    zmsstatistic --> zmsentities
    zmsstatistic --> zmsslim
    zmsstatistic --> zmsclient

    zmsmessaging --> mellon
    zmsmessaging --> zmsclient
    zmsmessaging --> zmsentities
    zmsmessaging --> zmsslim

    zmsdb --> zmsentities
    zmsdb --> zmsdldb
    zmsdb --> mellon

    zmsclient --> zmsentities
    zmsclient --> zmsslim
    zmsclient --> mellon

    zmsentities --> mellon
    zmsslim --> mellon

    %% zmscitizenapi dependencies
    zmscitizenapi --> mellon
    zmscitizenapi --> zmsslim
    zmscitizenapi --> zmsclient
    zmscitizenapi --> zmsentities

    %% Build dependencies (dashed lines)
    zmscitizenapi -.-> zmsapi
    refarch_gateway -.-> zmscitizenapi
    zmscitizenview -.-> refarch_gateway

    %% Infrastructure provides runtime foundation
    PHPBASE -->|provides runtime for| zmsapi
    PHPBASE -->|provides runtime for| zmsadmin
    PHPBASE -->|provides runtime for| zmscalldisplay
    PHPBASE -->|provides runtime for| zmsstatistic
    PHPBASE -->|provides runtime for| zmsmessaging
    PHPBASE -->|provides runtime for| zmsdb
    PHPBASE -->|provides runtime for| zmsclient
    PHPBASE -->|provides runtime for| zmsentities
    PHPBASE -->|provides runtime for| zmsslim
    PHPBASE -->|provides runtime for| zmsdldb
    PHPBASE -->|provides runtime for| mellon
    PHPBASE -->|provides runtime for| zmscitizenapi

    %% Group refarch_gateway and zmscitizenview into a subgraph
    subgraph refarch["refarch"]
        style refarch stroke-dasharray:5
        refarch_gateway
        zmscitizenview
    end

    %% Group remaining modules into dashed PHP-style subgraph
    subgraph zms_modules["ZMS PHP Modules"]
        style zms_modules stroke-dasharray:5 5 1 5
        zmsapi
        zmsadmin
        zmscalldisplay
        zmsstatistic
        zmsmessaging
        zmsdb
        zmsclient
        zmsentities
        zmsslim
        zmsdldb
        mellon
        zmscitizenapi
    end

    %% Styling for the infrastructure foundation
    classDef foundation fill:#e3f2fd,stroke:#0277bd,stroke-width:3px

    %% Styling for the three modules
    classDef citizenapi fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef gateway fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef citizenview fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px

    class PHPBASE foundation
    class zmscitizenapi citizenapi
    class refarch_gateway gateway
    class zmscitizenview citizenview
```

The current appointment system of the city of Munich will be replaced by Zeitmanagementsystem (ZMS) provided by the state of Berlin.

This repository has the definition for PHP base Docker images for runtime.

The original Repository can be found at https://gitlab.com/eappointment/php-base

For more details on the project, see https://github.com/it-at-m/eappointment

## License
This repository is licensed as MIT

<hr />

Das derzeitige Terminsystem der Stadt München wird durch das vom Land Berlin bereitgestellte Zeitmanagementsystem (ZMS) ersetzt. 

Dieses Repository enthält die Definition für PHP-Basis-Docker-Images für Laufzeit.

Das Original-Repository finden Sie unter https://gitlab.com/eappointment/php-base

Weitere Einzelheiten über das Projekt finden Sie unter https://github.com/it-at-m/eappointment

## Lizenz
Dieses Repository ist lizenziert als MIT

<hr />

## Branch Naming Convention
To keep our branch names organized and easily understandable, we follow a specific naming convention for all branches created in this repository. Please adhere to this convention when creating new branches:

1. **type**: The type of work the branch represents. This should be one of the following:
   - `feature`: For new features, PHP Upgrade or enhancements.
   - `bugfix`: For bug fixes.
   - `hotfix`: For urgent fixes that need to be applied quickly.
   - `cleanup`: For code refactoring, or documentation updates.
   - `docs`: For updating documentation such as the README.md CODE_OF_CONDUCT.md LICENSE.md CHANGELOG.md CONTRIBUTING.md. Providing a ticket number or project for docs is optional.
   - `chore`: For maintaining and updating dependencies, libraries, PHP/Node/Twig Versions, or other maintenance work.

2. **project**: The project identifier. This should be:
   - `zms` for the ZMS project.
   - `mpdzbs` for the MPDZBS project.

3. **issue number**: The ticket or issue number related to this branch (use digits only). This helps track the branch to a specific issue in the project management system.

4. **description**: A brief, lowercase description of the branch's purpose, using only lowercase letters, numbers, and hyphens (`-`).

- Always use lowercase letters and hyphens for the description.
- The issue number should be a numeric ID corresponding to the relevant ticket or task.
- Descriptions should be concise and informative, summarizing the branch's purpose.

#### Examples

- **Feature Branch**: `feature-zms-12345-add-base-image-for-php-8-2`
- **Bugfix Branch**: `bugfix-mpdzbs-67890-fix-crash-on-startup`
- **Hotfix Branch**: `hotfix-zms-98765-critical-fix-for-login`
- **Cleanup Branch**: `cleanup-mpdzbs-11111-remove-unused-code`
- **Chore Branch**: `chore-zms-2964-composer-update`
- **Docs Branch**: `docs-zms-0000-update-readme` `docs-zms-release-40-update-changelog`

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/it-at-m/eappointment-php-base.svg?style=for-the-badge
[contributors-url]: https://github.com/it-at-m/eappointment-php-base/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/it-at-m/eappointment-php-base.svg?style=for-the-badge
[forks-url]: https://github.com/it-at-m/eappointment-php-base/network/members
[stars-shield]: https://img.shields.io/github/stars/it-at-m/eappointment-php-base.svg?style=for-the-badge
[stars-url]: https://github.com/it-at-m/eappointment-php-base/stargazers
[issues-shield]: https://img.shields.io/github/issues/it-at-m/eappointment-php-base.svg?style=for-the-badge
[issues-url]: https://github.com/it-at-m/eappointment-php-base/issues
[license-shield]: https://img.shields.io/github/license/it-at-m/eappointment-php-base.svg?style=for-the-badge
[license-url]: https://github.com/it-at-m/eappointment-php-base/blob/main/LICENSE
[product-screenshot]: images/screenshot.png

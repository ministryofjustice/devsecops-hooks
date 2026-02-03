# Changelog

## [1.4.0](https://github.com/ministryofjustice/devsecops-hooks/compare/v1.3.0...v1.4.0) (2026-02-03)


### Features

* **115-unit-test-cases:** created BATS test case ([#116](https://github.com/ministryofjustice/devsecops-hooks/issues/116)) ([6100ad8](https://github.com/ministryofjustice/devsecops-hooks/commit/6100ad8d5b9c96241b64fa789f2eb485705ce683))
* **115-unit-test:** add unit test cases ([#121](https://github.com/ministryofjustice/devsecops-hooks/issues/121)) ([aabd7de](https://github.com/ministryofjustice/devsecops-hooks/commit/aabd7de583ca89afb7139d98a592f0630322755b))
* **125-min-age:** added cooldown to dependabot ([#126](https://github.com/ministryofjustice/devsecops-hooks/issues/126)) ([9c5db3f](https://github.com/ministryofjustice/devsecops-hooks/commit/9c5db3f5d8736dc03181fef9be0df2137838f6ee))
* **94-copilot:** added github copilot instructions ([#127](https://github.com/ministryofjustice/devsecops-hooks/issues/127)) ([2fc171c](https://github.com/ministryofjustice/devsecops-hooks/commit/2fc171cd0657c65853ddb81289b6ef2642821e3c))


### Bug Fixes

* **130-double-execution:** set pass_filename to false ([#131](https://github.com/ministryofjustice/devsecops-hooks/issues/131)) ([79b1c6b](https://github.com/ministryofjustice/devsecops-hooks/commit/79b1c6b7d55837a8de7366f6cef85803cf3e74a3))
* **85-ensure-staging-files:** added pre-commit and staged flags ([#86](https://github.com/ministryofjustice/devsecops-hooks/issues/86)) ([0488b25](https://github.com/ministryofjustice/devsecops-hooks/commit/0488b2567892942037c4c31b17a795f77ed19c3f))
* **92-strict-scan:** added gitleaks configuration for low entropy ([#98](https://github.com/ministryofjustice/devsecops-hooks/issues/98)) ([2e37b24](https://github.com/ministryofjustice/devsecops-hooks/commit/2e37b243060f2aed095fe5df6536c0b9aa4816db))
* **pre-commit:** remove --pre-commit flag ([#82](https://github.com/ministryofjustice/devsecops-hooks/issues/82)) ([020bfd5](https://github.com/ministryofjustice/devsecops-hooks/commit/020bfd5f61831b7a426082de6f11ef4f8467a18f))
* **sca:** updated pipeline ([#109](https://github.com/ministryofjustice/devsecops-hooks/issues/109)) ([a30ac6a](https://github.com/ministryofjustice/devsecops-hooks/commit/a30ac6a3947e033d2e3ecd48ace0c83008cd9984))

## [1.3.0](https://github.com/ministryofjustice/devsecops-hooks/compare/v1.2.0...v1.3.0) (2025-12-29)


### Features

* **25-renovate:** execute renovate in CI ([#29](https://github.com/ministryofjustice/devsecops-hooks/issues/29)) ([3b105d2](https://github.com/ministryofjustice/devsecops-hooks/commit/3b105d2c64e5a660f4f6abdbd1532e93c80cf1d3))
* **51-workflow:** added workflow diagram ([#52](https://github.com/ministryofjustice/devsecops-hooks/issues/52)) ([13775dd](https://github.com/ministryofjustice/devsecops-hooks/commit/13775ddaa75359ae06f7afa58eede21903eb8add))
* **52-dependency:** integrated centralised workflow ([#54](https://github.com/ministryofjustice/devsecops-hooks/issues/54)) ([1974716](https://github.com/ministryofjustice/devsecops-hooks/commit/19747163a9937a474b7b9212ffae53254d25bfa3))
* **67-allow-ci-execution:** added enviornment variables ([#68](https://github.com/ministryofjustice/devsecops-hooks/issues/68)) ([a3f792a](https://github.com/ministryofjustice/devsecops-hooks/commit/a3f792a077eb216c2e9ac9a4c2eac34cea618ee2))


### Bug Fixes

* **10-sca:** updated sca action to default to base branch ([#66](https://github.com/ministryofjustice/devsecops-hooks/issues/66)) ([e2bd485](https://github.com/ministryofjustice/devsecops-hooks/commit/e2bd4852c532d2b70d1d2e33f2c2693fb237983b))
* **31-action:** corrected renovate configuration ([#33](https://github.com/ministryofjustice/devsecops-hooks/issues/33)) ([ba019b6](https://github.com/ministryofjustice/devsecops-hooks/commit/ba019b607374a87a5a697814118d0690fc702031))
* **31-renovate:** fix renovate configuration ([#36](https://github.com/ministryofjustice/devsecops-hooks/issues/36)) ([90c8634](https://github.com/ministryofjustice/devsecops-hooks/commit/90c863490705d6f9cc3f2e765496bac463988046))
* **53-integrate:** integrate MoJ SCA action ([#62](https://github.com/ministryofjustice/devsecops-hooks/issues/62)) ([bfac6b4](https://github.com/ministryofjustice/devsecops-hooks/commit/bfac6b4462d5fa5a9c28e7c37c8faeadeb4a3ef2))
* **53-integrate:** remove workflow_dispatch ([#60](https://github.com/ministryofjustice/devsecops-hooks/issues/60)) ([1ea9560](https://github.com/ministryofjustice/devsecops-hooks/commit/1ea95600636be8383499db80e8eb9e5e08761039))
* **renovate:** pin to v44.2.0 commit SHA ([#43](https://github.com/ministryofjustice/devsecops-hooks/issues/43)) ([80f53e8](https://github.com/ministryofjustice/devsecops-hooks/commit/80f53e85bdfd383299022f39e2b850316f0ad057))

## [1.2.0](https://github.com/ministryofjustice/devsecops-hooks/compare/v1.1.0...v1.2.0) (2025-12-15)


### Features

* **22-gitleaks-for-staged-files-only:** GitLeaks for staged files only ([#23](https://github.com/ministryofjustice/devsecops-hooks/issues/23)) ([ca36746](https://github.com/ministryofjustice/devsecops-hooks/commit/ca36746802cb6f24f0e9f208a85f561b6ec9a53f))

## [1.1.0](https://github.com/ministryofjustice/devsecops-hooks/compare/v1.0.0...v1.1.0) (2025-12-05)


### Features

* **devsecops-9:** update githook version to v1.0.0 ([c882451](https://github.com/ministryofjustice/devsecops-hooks/commit/c8824511622ddc8e919c8b59fb9c1f5feb04b9d2))
* **devsecops-9:** update githook version to v1.0.0 ([f74dda1](https://github.com/ministryofjustice/devsecops-hooks/commit/f74dda1c3c8fa9d00a7dd2dbd2533c23218c3189))

## 1.0.0 (2025-12-05)


### Features

* **AS-001:** pre commit git hook ([459f39b](https://github.com/ministryofjustice/devsecops-hooks/commit/459f39b18723a8b5efdd60992da12f6bb4d246d2))
* **AS-002:** add release please ([4ce725d](https://github.com/ministryofjustice/devsecops-hooks/commit/4ce725d482f569ba05e7f2e724c8120c1e418d31))
* **AS-002:** add release please to the repository ([0653f53](https://github.com/ministryofjustice/devsecops-hooks/commit/0653f53eef03e54d338e7ca8e44f8444b2d9f439))
* **AS-002:** added package.json ([c59ab63](https://github.com/ministryofjustice/devsecops-hooks/commit/c59ab633ab01b8254e0a2bc4c35aae5c289219d0))
* **AS-002:** added package.json ([c9ca060](https://github.com/ministryofjustice/devsecops-hooks/commit/c9ca060c0dc7396265560c11eb2cca1c97d341f1))
* **AS-002:** corrected configurtion file ([7db863f](https://github.com/ministryofjustice/devsecops-hooks/commit/7db863fbfb8de38927c01e21f5c565e85432b203))
* **AS001:** added gitfiles ([f43a972](https://github.com/ministryofjustice/devsecops-hooks/commit/f43a972029467272e1ce7935a94004c05b60840b))
* **AS001:** added pre-commit-config.yaml ([206df32](https://github.com/ministryofjustice/devsecops-hooks/commit/206df32b7ce5e499d5bd164e11c32fe010a6a544))
* **AS001:** added scripts, dockerfile and precommit hooks ([5ac5ee0](https://github.com/ministryofjustice/devsecops-hooks/commit/5ac5ee040e2fe4508eddb1e312fded0f31ecf0c4))
* **AS001:** added stages ([c03c9f7](https://github.com/ministryofjustice/devsecops-hooks/commit/c03c9f705031c122b4a77da8732397b71a7120ac))
* **AS001:** corrected yaml ([714f180](https://github.com/ministryofjustice/devsecops-hooks/commit/714f180db8ff03ee7170883634ab200d1ad9e0a4))
* **AS001:** corrected yaml ([3cbaf8e](https://github.com/ministryofjustice/devsecops-hooks/commit/3cbaf8ea849737a9c8f50af1bcbc4648de33293e))
* **AS001:** corrected yaml ([6d74a36](https://github.com/ministryofjustice/devsecops-hooks/commit/6d74a3628a1cc87075c75f5660d6611870607a95))
* **AS001:** removed python version ([384bba1](https://github.com/ministryofjustice/devsecops-hooks/commit/384bba13f83e5b055ed492e8534a8c402537a23a))
* **AS001:** removed python version ([5dfa96a](https://github.com/ministryofjustice/devsecops-hooks/commit/5dfa96a42f1b383ddf80319e80de8d38c3c8d288))
* **AS001:** updated dockerfile ([86d162d](https://github.com/ministryofjustice/devsecops-hooks/commit/86d162d34ea7f5b5c15e9ad9c2392f0cba009268))
* **devsecops-9:** add spellcheck ([c0c34e2](https://github.com/ministryofjustice/devsecops-hooks/commit/c0c34e258f2d4727359184dab284518623f16649))
* **devsecops-9:** add spellcheck ([d10b662](https://github.com/ministryofjustice/devsecops-hooks/commit/d10b662a602e1a80bc93015f7c36c39301937ac4))


### Bug Fixes

* **AS-001:** added additional stage support ([dc45a23](https://github.com/ministryofjustice/devsecops-hooks/commit/dc45a23c33a3beab55e974c09dcd206b48f8f3b0))
* **AS-001:** added commit-msg ([ddc20f2](https://github.com/ministryofjustice/devsecops-hooks/commit/ddc20f2051aae31b9bfc1784460187da32a21155))
* **AS-001:** minor lint fixes ([a5bd873](https://github.com/ministryofjustice/devsecops-hooks/commit/a5bd873c96a914b5be53d35085f8f554ff9c4720))
* **AS-001:** minor lint fixes ([d98621a](https://github.com/ministryofjustice/devsecops-hooks/commit/d98621a83f21c72d9d34655966e70621c06c8865))
* **AS-001:** updated README.MD ([09ef526](https://github.com/ministryofjustice/devsecops-hooks/commit/09ef526a861a105a9bf16a96e1ba4413b414af4c))
* **AS001-pre-commit:** changed to commit SHA ([f3a9300](https://github.com/ministryofjustice/devsecops-hooks/commit/f3a930047bf1373b540608f54fcd7619b57801c8))
* **AS001-pre-commit:** changed to main branch ([d41a1e7](https://github.com/ministryofjustice/devsecops-hooks/commit/d41a1e759f872342bfe516690619e6adbf83bb54))
* **AS001-pre-commit:** changed to main branch ([b640e64](https://github.com/ministryofjustice/devsecops-hooks/commit/b640e64819065b469248c2080521a7dc9cf3e848))
* **AS001-pre-commit:** README.MD ([0d3b372](https://github.com/ministryofjustice/devsecops-hooks/commit/0d3b37243292b6e955d9f969a4a202b022deabf9))

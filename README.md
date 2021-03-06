# change_requirements

## Introduction

When using Ansible, it is sometimes handy to use the [`ansible-galaxy`](https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#installing-multiple-roles-from-a-file) command and its `requirements.yml` file to download an Ansible role set.

The script `change_requirements.pl` allows you to manipulate this requirements.yml file by changing the GIT protocol to https or SSH mode.


## Requirement

- Perl
- git
- file `requirements.yml`


## Tested with

* Perl v5.24.1


## Utilization

```
./change_requirements.pl --mode <ssh|https> [--login <login> --password <pass> or --ask-password if https] requirements.yml
                         [--verbose]
```

## Examples

By using `change_requirements.pl`, you should redirect output into a file, for example : `requirements_https.yml` or `requirements_ssh.yml`.

**Example1 (https) :**

```
./change_requirements.pl --mode https requirements.yml
---
- src: https://gitlab.home.fr/myproject/ansible-role-icinga2.git
  scm: git
  version: c2959c02b0deaa8576b2319295ba4fd9ae2681f7

- src: https://gitlab.home.fr/myproject/ansible-role-mariadb.git
  scm: git
  version: d84edb37f9f4f906c0628a9ca329d733a51b37bd

```

**Example2 (ssh) :**

```
./change_requirements.pl --mode ssh requirements.yml
---
- src: git@gitlab.home.fr:myproject/ansible-role-icinga2.git
  scm: git
  version: c2959c02b0deaa8576b2319295ba4fd9ae2681f7

- src: git@gitlab.home.fr:myproject/ansible-role-mariadb.git
  scm: git
  version: d84edb37f9f4f906c0628a9ca329d733a51b37bd
```

**Example3 (with login) :**

```
./change_requirements.pl --mode https requirements.yml --login sgaudart (--ask-password)
---
- src: https://sgaudart@gitlab.home.fr/myproject/ansible-role-icinga2.git
  scm: git
  version: c2959c02b0deaa8576b2319295ba4fd9ae2681f7

- src: https://sgaudart@gitlab.home.fr/myproject/ansible-role-mariadb.git
  scm: git
  version: d84edb37f9f4f906c0628a9ca329d733a51b37bd

```

## Todo

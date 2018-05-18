#!/usr/bin/env bash

## Исходные данные проекта
rsync -a -v -r -q \
  --exclude '.git' \
  --exclude 'node_modules' \
  /src/ /home/

## Компиляция проекта
npm install --silent --unsafe-perm
ng set warnings.typescriptMismatch=false
make build

## Результат
rsync -a -v -r -q \
  --stats \
  --delete \
  /home/dist/ /src/dist/

## Всё ок
touch /src/dist/.ok
chmod 666 /src/dist/.ok

# Презентация на тему ```Ansible на примере непрерывной поставки приложения```

[Презентация на GoogleDocs](https://docs.google.com/presentation/d/1jBKYXVf2Qup2i2KoHQxDE6R3Nktvhl1iyzaxOofIoQ0/edit?usp=sharing)

## Практическая часть
### 0. Предподготовка
- сгенерировать ssh keys `ssh-keygen` id_rsa и id_rsa.pub в каталог tpl/.ssh
- подготовить 5 виртуальных машины (registry, test1, prod1, prod2, nginx)
  - в каталогe tpl/vagrant `vagrant up`
- установить docker-ls https://github.com/mayflower/docker-ls для просмотра registry

### 1. Создать go-приложение
`cp tpl/webapp.go ./`

### 2. Скомпилировать
`make build`

### 3. Подготовить Dockerfile
`cp tpl/Dockerfile ./`

### 4.  Сделать образ
`make build_image`

### 5. Запустить и проверить
`make run`
- http://localhost:8000

### 6. Создаем файловую структуру для ansible
`make env`
- про каталоги
- про ansible.cfg
- про ssh

### 7. Заполняем inventory
```
registry	ansible_host=127.0.0.1 ansible_port=2222
localhost

[docker-registry]
registry
```
- про localhost

### 8. Устанавливаем роли
`make roles`
- про роли

### 9. Заполняем group_vars/all
```
system:
  docker:
    registry:
      domain: registry.example.com
      port:  5000
      host: registry
```
- про иерархию переменных

### 10. Создаем site.yml
`cp tpl/ansible/site.yml infrastructure/`
- про организацию плейбуков

### 11. Создаем common.yml
`cp tpl/ansible/common.yml infrastructure/`
- роль docker

### 12. Создаем playbook registry.yml
`cp tpl/ansible/registry.yml infrastructure/`
- про playbook
- про local_action

### 13. Запускаем site.yml
`make site`

### 14. Запускаем локально common.yml
`make local`
- про inventory

### 15. Проверяем registry
`make list`

### 16. Пушим образ в registry
`make docker_push`

### 17. Проверяем в registry загрузку образа
`make list`

### 18. Добавляем в inventory test1
```
test1	ansible_host=127.0.0.1 ansible_port=2223

[webapp]
test1
```

### 19. Создаем плейбук для приложения
`cp tpl/ansible/webapp.yml infrastructure/`

### 20. Создаем group_vars/webapp
```
system:
  webapp:
    port: 8000
```
- про групповые перемменные

### 21. Создаем host_vars/test1
```
system:
  webapp:
    version: 0.0.1
```
- про групповые перемменные

### 22. Запускаем site.yml
`make site HOST=test1`
- про limit-host

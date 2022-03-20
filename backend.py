#!/usr/bin/python3
import os
import socket
from json import dumps, loads

from PySide2.QtCore import QObject, QThread, Signal, Slot
from mailer import Mailer


def settings_read(key=None) -> str:
    with open('settings.json') as rf:
        if key in ['theme', 'color', 'language']:
            return loads(rf.read()).get(key)
        else:
            return rf.read()


def settings_write(data) -> None:
    if isinstance(data, dict):
        data_up = loads(settings_read())
        data_up.update(data)

        with open('settings.json', 'w') as wf:
            wf.write(dumps(data_up))


class Thread(QThread):
    def __init__(self):
        super().__init__()

    def run(self):
        pass

    def stop(self):
        self.terminate()


class Worker(QThread):
    def __init__(self, send, **kwargs):
        super().__init__()
        self.data = kwargs
        self.send_email = send
        self.status = bool()

    def run(self):
        data = self.data

        try:
            result = self.send_email(receiver=data['receiver'],
                                     subject=data['subject'],
                                     message=data['message'],
                                     file=data['file'],
                                     image=data['image'],
                                     audio=data['audio'])
        except (socket.error, socket.gaierror):
            result = False

        self.status = result

    def stop(self):
        self.terminate()


class Mail:
    image = None
    audio = None
    filename = None
    currentStatusChanged = Signal(bool, arguments=['status'])

    @Slot(str, str)
    def set_login(self, email, password):
        self.email = email
        self.password = password
        self.mail = Mailer(email=email, password=password)

    @Slot(int, int, bool)
    def set_settings(self, repeat=1, sleep=0, multi=False):
        if self.email.endswith('gmail.com'):
            provider = self.mail.GMAIL
        else:
            provider = self.mail.MICROSOFT

        self.mail.settings(repeat=repeat,  # To Repeat Sending
                           sleep=sleep,  # To Sleep After Send Each Message
                           provider=provider,  # Set Maill Service
                           multi=multi)

    @Slot()
    def send_message(self):
        self.thread = Worker(self.mail.send,
                             receiver=self.receivers,
                             subject=self.subject,
                             message=self.message,
                             image=self.image,
                             audio=self.audio,
                             file=self.filename)
        self.thread.start()
        self.thread.finished.connect(lambda: self.currentStatusChanged.emit(self.thread.status))

    @Slot()
    def cancel_message(self):
        self.thread.stop()

    @Slot(list, list, list, str, str)
    def set_info(self, receivers, cc, bcc, subject, message):
        self.receivers = receivers if receivers else None
        self.cc = cc if cc else None
        self.bcc = bcc if bcc else None
        self.message = message
        self.subject = subject

    @Slot(str, str, str)
    def set_attach(self, filename=None, image=None, audio=None):
        if filename:
            self.file = filename.replace('file:///', '')

        if image:
            self.image = image.replace('file:///', '')

        if audio:
            self.audio = audio.replace('file:///', '')


class Backend(QObject, Mail):
    warningChanged = Signal(str, arguments=['warning'])

    def __init__(self):
        super().__init__()

    @Slot(str)
    def set_language(self, language):
        settings_write(data={'language': language})

    @Slot(str)
    def set_theme(self, theme):
        settings_write(data={'theme': theme})

    @Slot(str)
    def set_color(self, color):
        settings_write(data={'color': color})

    @Slot(result=str)
    def get_color(self):
        return settings_read(key='color')

    @Slot(result=str)
    def get_language(self):
        return settings_read(key='language')

    @Slot(result=str)
    def get_theme(self):
        return settings_read(key='theme')

    @Slot(str, result=str)
    def read_file(self, path):
        filename = path.replace('file:///', '')
        file_size = (os.path.getsize(filename) / 1024) > 50

        if file_size:
            self.warningChanged.emit('sizeLimited')

        with open(filename, encoding='utf-8') as rf:
            return rf.read(50000)

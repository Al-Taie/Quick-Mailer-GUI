#!/usr/bin/python3

import sys

from PySide2.QtCore import QTranslator, Qt
from PySide2.QtGui import QGuiApplication, QIcon
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtQuickControls2 import QQuickStyle

from backend import Backend
import res_rc
import qml_rc

# SET STYLE
QQuickStyle.setStyle('Material')

t = QTranslator()
t.load(':arabic')


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    app.setOrganizationName('Al-Taie')
    app.setOrganizationDomain('instagram.com/9_tay')
    app.setApplicationName('Quick-Mailer Modern GUI')
    # app.setWindowIcon(QIcon('qrc:/appicon'))

    engine = QQmlApplicationEngine()
    backend = Backend()

    if backend.get_language() == 'ar':
        app.installTranslator(t)
        app.setLayoutDirection(Qt.RightToLeft)

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty('con', backend)

    # Load splash screen
    engine.load('qml/splash.qml')

    if not engine.rootObjects():
        sys.exit(-1)
    app.exec_()

    # Load Main Window
    engine.load('qml/main.qml')

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())

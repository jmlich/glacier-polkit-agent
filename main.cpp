/****************************************************************************************
**
** Copyright (C) 2021 Chupligin Sergey <neochapay@gmail.com>
** All rights reserved.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the author nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

#include <QGuiApplication>
#include <QtQml>
#include <QtQuick/QQuickView>

#include <PolkitQt1/Subject>

#include <systemd/sd-login.h>
#include <unistd.h>
#include <string>

#include <glacierapp.h>
#include "polkitinterface.h"

int main(int argc, char *argv[])
{
    QGuiApplication *app = GlacierApp::app(argc, argv);
    app->setQuitOnLastWindowClosed(false);

    PolkitQt1::UnixSessionSubject subject(QGuiApplication::applicationPid());

    PolkitInterface *interface = new PolkitInterface();
    interface->registerListener(subject, "/org/glacier/polkit/AuthenticationAgent");

    QQmlApplicationEngine *engine = GlacierApp::engine(app);
    QQmlContext *context = engine->rootContext();
    context->setContextProperty("polkitInterface", interface);

    QQuickWindow *window = GlacierApp::showWindow();
    window->setTitle(QObject::tr("Authentication"));
    window->hide();

    QObject::connect(interface, &PolkitInterface::openAuthWindow, window, &QQuickWindow::show);
    QObject::connect(interface, &PolkitInterface::closeAuthWindow, window, &QQuickWindow::hide);

    return app->exec();
}

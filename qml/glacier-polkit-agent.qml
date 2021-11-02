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

import QtQuick 2.6
import QtQuick.Window 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0


ApplicationWindow {
    id: appWindow

    initialPage: Page {
        id: root

        headerTools: HeaderToolsLayout {
            title: qsTr("Authentication")
        }

        Column {
            spacing: Theme.itemSpacingSmall
            width: parent.width - Theme.itemSpacingSmall*2
            height: parent.height - Theme.itemHeightLarge

            anchors{
                top: parent.top
                topMargin: Theme.itemSpacingSmall
                left: parent.left
                leftMargin: Theme.itemSpacingSmall
            }

            Label {
                id: messageLabel
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
            }

            Label{
                text: qsTr("Enter you password:")
                font.pixelSize: Theme.fontSizeSmall
            }

            TextField {
                id: password
                width: parent.width
                anchors.margins: Theme.itemSpacingLarge
                echoMode: TextInput.Password
            }
        }

        Button {
            id: cancel
            text: qsTr("Cancel")
            width: parent.width / 2
            height: Theme.itemHeightLarge
            anchors {
                left: parent.left
                bottom: parent.bottom
            }

            onClicked: {
                polkitInterface.rejected();
            }
        }

        Button {
            id: accept
            text: qsTr("Accept")
            enabled: password.text.length > 3 ? true : false
            width: parent.width / 2
            height: Theme.itemHeightLarge
            primary: true
            anchors {
                left: cancel.right
                bottom: parent.bottom
            }
            onClicked: {
                polkitInterface.accepted(password.text)
                password.text = ""
            }
        }
    }

    Connections{
        target: polkitInterface
        function onMessageChanged() {
            messageLabel.text = polkitInterface.message
        }
    }
}

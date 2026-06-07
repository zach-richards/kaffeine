// src/app/tray_icon.h
#pragma once
#include <KStatusNotifierItem>

class TrayIcon {
public:
    TrayIcon();
    KStatusNotifierItem* getItem() const;

private:
    KStatusNotifierItem *item;
    bool isOn = true;
    void onClicked();
};
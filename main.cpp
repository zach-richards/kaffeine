// main.cpp

#include <KStatusNotifierItem>

int main()
{
    KStatusNotifierItem item;
    item.setIconByName("face-smile");
    item.setToolTipTitle("Hello World");
    item.setToolTipSubTitle("This is a tooltip from KStatusNotifierItem.");
    item.setStatus(KStatusNotifierItem::Active);
    return 0;
}
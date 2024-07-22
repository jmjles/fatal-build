import QtQuick 1.1
import CursorShape 1.0
import StandardToolTip 1.0

Row {
    id: rowQuality
    height: parent.height
    
    QualityMenuItem {
        property int index: 0;
    }
    QualityMenuItem {
        property int index: 1;
    }
    QualityMenuItem {
        property int index: 2;
    }
    QualityMenuItem {
        property int index: 3;
    }
    QualityMenuItem {
        property int index: 4;
    }
}
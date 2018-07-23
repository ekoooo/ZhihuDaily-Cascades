/*
 * Misc.hpp
 *
 *  Created on: 2018年7月18日
 *      Author: liuwanlin
 */

#ifndef MISC_HPP_
#define MISC_HPP_

#include <QObject>

class Misc : public QObject {
    Q_OBJECT

    public:
        Misc();
        virtual ~Misc() {};

        Q_INVOKABLE void invokeViewIamge(QString path);
        Q_INVOKABLE void clearCache();
};

#endif /* MISC_HPP_ */

ALTER TABLE `customers`
    ADD KEY `salesRepEmployeeNumber` (`salesRepEmployeeNumber`),
    ADD CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`salesRepEmployeeNumber`) REFERENCES `employees` (`employeeNumber`);

ALTER TABLE `products`
  ADD KEY `productLine` (`productLine`),
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`productLine`) REFERENCES `productlines` (`productLine`);

ALTER TABLE `payments`
    ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`);

ALTER TABLE `orders`
    ADD KEY `customerNumber` (`customerNumber`),
    ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerNumber`) REFERENCES `customers` (`customerNumber`);

ALTER TABLE `orderdetails`
    ADD KEY `productCode` (`productCode`),
    ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`orderNumber`) REFERENCES `orders` (`orderNumber`),
    ADD CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`productCode`) REFERENCES `products` (`productCode`);

ALTER TABLE `employees`
    ADD KEY `reportsTo` (`reportsTo`),
    ADD KEY `officeCode` (`officeCode`),
    ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`reportsTo`) REFERENCES `employees` (`employeeNumber`),
    ADD CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`officeCode`) REFERENCES `offices` (`officeCode`);

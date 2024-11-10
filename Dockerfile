# Use CentOS 7 as the base image
FROM centos:7

# Use CentOS Vault mirrors to avoid repository issues
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Install necessary tools
RUN yum -y install java-1.8.0-openjdk-devel rpm-build

# Set up RPM build environment
RUN mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Copy the Java source code to the container
COPY Calculator.java /root/rpmbuild/SOURCES/

# Compile the Java code
RUN javac /root/rpmbuild/SOURCES/Calculator.java

# Create a script to run the Java program
RUN echo -e '#!/bin/bash\njava -cp /usr/local/bin Calculator' > /root/rpmbuild/SOURCES/run_calculator.sh && \
    chmod +x /root/rpmbuild/SOURCES/run_calculator.sh

# Create RPM spec file
RUN echo "Name: calculator" > /root/rpmbuild/SPECS/calculator.spec && \
    echo "Version: 1.0" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "Release: 1" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "Summary: A simple Java calculator" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "License: GPL" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "Source: Calculator.java" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "%description" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "This is a simple calculator application written in Java." >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "%prep" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "# No need to unpack Calculator.java, just copy it directly" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "%build" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "%install" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "mkdir -p %{buildroot}/usr/local/bin" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "cp /root/rpmbuild/SOURCES/Calculator.class %{buildroot}/usr/local/bin/" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "cp /root/rpmbuild/SOURCES/run_calculator.sh %{buildroot}/usr/local/bin/" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "%files" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "/usr/local/bin/Calculator.class" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "/usr/local/bin/run_calculator.sh" >> /root/rpmbuild/SPECS/calculator.spec && \
    echo "%changelog" >> /root/rpmbuild/SPECS/calculator.spec

# Build the RPM
RUN rpmbuild -ba /root/rpmbuild/SPECS/calculator.spec

# Install the RPM package to test it
RUN yum -y localinstall /root/rpmbuild/RPMS/x86_64/calculator-1.0-1.x86_64.rpm

# Run the calculator to verify installation
CMD ["/usr/local/bin/run_calculator.sh"]



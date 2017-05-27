(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� g)Y �[o�0�yxᥐ�P�21�BJ�AI`�S<r�si���>;e����R�i����s|αq{q��0�`k繵w�'t�zzW|�NE��	� ����U�Wㅎ��� ����I��� �bl�(:�{����B���@�]�� N�#� z+�éM� @�����B�]�!��Fv3�|���N�ou[B3�0E�18�^&�	=��#�K#�A?E8�=��G�T��Ț�-��p`�O�nyԏq3i[��)-��!�Z�!��M��4Z�Q�	�&mmjkm"���Y�P�ds.˚9�4Y�CɆ<4�k=�S���\�̌~�'����N|�ɶs+"�� E�'����KY��Ÿ��Q�$��1�<1eR�9���8����V����].��q_�*��*
YW��,-�DG^5��O�CO׾%����.򷹆(t[��hڠ����#�]����2�K���x07[U�3ݟ��l�4C�ڭq��NeK_�׼D/����t�؊�ӹ��*���d,�O{ ?O �������f���¨.D�q_vh�C|��Ab?j.O�l�B�	*�;&�fC@Jv{y\L�����-�--W��i�M��C���!�6��
�ܨ<�>���Cv�)t�5m��O�<���z�����)��.YU�Ū��n��b��@Y�E�/���[X$Ϲ���B�s�yS�-�CY!�&�Q�->|��n��W/�O����`0��`0��`0��`0���O�o]_ (  
#!/usr/bin/env bash

# set these to taste - NOTE: can't use "~" for your home folder
psma_version="201808"
output_folder="/Users/hugh.saalmans/tmp"

/Applications/Postgres.app/Contents/Versions/10/bin/pg_dump -Fc -d geo -n gnaf_${psma_version} -p 5433 -U postgres -f ${output_folder}/gnaf-${psma_version}.dmp
echo "GNAF schema exported to dump file"

/Applications/Postgres.app/Contents/Versions/10/bin/pg_dump -Fc -d geo -n admin_bdys_${psma_version} -p 5433 -U postgres -f ${output_folder}/admin-bdys-${psma_version}.dmp
echo "Admin Bdys schema exported to dump file"

# OPTIONAL - copy files to AWS S3 and allow public read access (requires awscli installed)
cd ${output_folder}

for f in *-${psma_version}.dmp;
  do
    aws --profile=default s3 cp --storage-class REDUCED_REDUNDANCY ./${f} s3://minus34.com/opendata/psma-${psma_version}/${f};
    aws --profile=default s3api put-object-acl --acl public-read --bucket minus34.com --key opendata/psma-${psma_version}/${f}
    echo "${f} copied to S3"
  done
